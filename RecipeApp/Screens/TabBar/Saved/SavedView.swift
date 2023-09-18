//
//  SavedView.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 08/09/2023.
//

import UIKit
import Combine
import SwipeCellKit
import FirebaseAuth

protocol SavedViewProtocol: UIViewController, AnyObject {
    var presenter: SavedPresenterProtocol? { get set }
}

final class SavedView: UIViewController, SavedViewProtocol {
    enum Constants {
        static let swipeActionTitle = "Delete"
    }
    
    var presenter: SavedPresenterProtocol?
    private let refreshControl = UIRefreshControl()
    private lazy var savedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        Home.Layout.apply(layout)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        Home.CollectionView.apply(collectionView, refreshControl: refreshControl)
        return collectionView
    }()
    
    //MARK: Combine properties
    private var cancellables = Set<AnyCancellable>()
    private let refreshSubject = PassthroughSubject<Void, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = GeneralStyle.mainBackgroundColor
        presenter?.fetchIngredients()
        setupDelegates()
        addSubview()
        setupAutoLayout()
        addBindings()
    }
}

private extension SavedView {
    func setupDelegates() {
        savedCollectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCellConstants.productCellIdentifier)
        savedCollectionView.dataSource = self
        savedCollectionView.delegate = self
    }
    
    func addSubview() {
        view.addSubviewAndDisableAutoresizing(savedCollectionView)
    }
    
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            savedCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            savedCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            savedCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            savedCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func addBindings() {
        refreshControl.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)
        
        presenter?.ingredientsPublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] _ in
                self?.savedCollectionView.reloadData()
            }).store(in: &cancellables)
        
        refreshSubject
            .sink { [weak self] _ in
                self?.presenter?.fetchIngredients()
                self?.refreshControl.endRefreshing()
            }.store(in: &cancellables)
    }
    
    @objc func refreshTriggered() {
        refreshSubject.send()
    }
}

extension SavedView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SwipeCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .drag
        return options
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right,
              let ingredients = self.presenter?.ingredients,
              !ingredients.isEmpty else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: Constants.swipeActionTitle) { action, indexPath in
            let ingredient = ingredients[indexPath.row]
            if let user = Auth.auth().currentUser {
                self.presenter?.removeIngredient(ingredient: ingredient, forUser: user.uid)
                self.presenter?.fetchIngredients()
            }
        }
    
        deleteAction.hidesWhenSelected = true
        
        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.ingredients?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCellConstants.productCellIdentifier, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
        cell.delegate = self
        cell.configure(with: presenter?.ingredients?[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - HomeConstants.productCellWidthIset, height: HomeConstants.productCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductCell else { return }
        cell.showAnimation {
            if let id = self.presenter?.ingredients?[indexPath.row] {
                self.presenter?.openDetailedPage(with: id.foodUrl)
            }
        }
    }
}
