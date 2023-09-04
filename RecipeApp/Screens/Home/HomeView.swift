//
//  HomeView.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 19.08.2023.
//

import UIKit
import PhotosUI

protocol HomeViewProtocol: AnyObject {
    var presenter: HomePresenterProtocol? { get set }
    var navigationController: UINavigationController? { get }
}

final class HomeView: UITabBarController, HomeViewProtocol, HomeHeaderViewDelegate, HomeSearchDelegate {
    var presenter: HomePresenterProtocol?
    
    private lazy var homeHeaderView: HomeHeaderView = {
        let view = HomeHeaderView(frame: .zero)
        return view
    }()
    
    private lazy var homeSearchView: HomeSearchView = {
        let view = HomeSearchView()
        return view
    }()
    
    private lazy var productCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewControllers = TabBarConfiguration.shared.setupTabBarItems()
        setupSubviews()
        setupAutoLayout()
        setupDelegates()
        disableBackNavigation()
        setupProductCell()
    }
    
    func presentPicker(_ picker: PHPickerViewController) {
        present(picker, animated: true, completion: nil)
    }
    
    func openFilterSearch() {
        presenter?.openFilterSearchView()
    }
}

private extension HomeView {
    func setupProductCell() {
        productCollectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
    }
    
    func disableBackNavigation() {
        navigationItem.hidesBackButton = true
    }
    
    func setupDelegates() {
        homeHeaderView.delegate = self
        homeSearchView.delegate = self
    }
    
    func setupSubviews() {
        view.addSubviewAndDisableAutoresizing(homeHeaderView)
        view.addSubviewAndDisableAutoresizing(homeSearchView)
        view.addSubviewAndDisableAutoresizing(filterButton)
        view.addSubviewAndDisableAutoresizing(segmentedControl)
        view.addSubviewAndDisableAutoresizing(productCollectionView)
    }
    
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            homeHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeHeaderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            homeHeaderView.heightAnchor.constraint(equalToConstant: 60),
            homeHeaderView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            homeSearchView.topAnchor.constraint(equalTo: homeHeaderView.bottomAnchor, constant: 10),
            homeSearchView.leadingAnchor.constraint(equalTo: homeHeaderView.leadingAnchor, constant: -10),
            homeSearchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            productCollectionView.topAnchor.constraint(equalTo: homeSearchView.bottomAnchor, constant: 20),
            productCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productCollectionView.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
}

extension HomeView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        cell.configure(with:  "Product\(indexPath)",
                       imagePath: UIImage(named: "create_receipt")!,
                       timeValueText: "10")
        return cell
    }
}
