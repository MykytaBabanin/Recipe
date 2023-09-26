//
//  HomeView.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 19.08.2023.
//

import UIKit
import Combine
import FirebaseAuth
import SwipeCellKit

enum HomeState {
    case empty
    case loading
    case loaded
}

protocol HomeViewProtocol: UIViewController, AnyObject {
    var presenter: HomePresenterProtocol? { get set }
    var navigationController: UINavigationController? { get }
    var fatSearchProvider: FatSecretProviderProtocol { get }
}

enum HomeConstants {
    static let navigationTitle = "Search Ingredients"
    static let searchPlaceholder = "Search recipe"
    static let filterImage = UIImage(named: "filter")
    static let tappableAnimationDuration = 1.0
    static let registrationAlertTitle = "Registration Error"
    static let alertActionButton = "Ok"
    static let defaultAmountOfCells = 10
    static let welcomeAnimation = "welcome"
    static let productCellWidthIset: CGFloat = 30
    static let productCellHeight: CGFloat = 70
    static let welcomeViewHeight: CGFloat = 100
    static let welcomeViewTop: CGFloat = 10
    static let productCollectionViewTop: CGFloat = 20
    static let cellInsets: CGFloat = 4
    
    static let swipeElementBackgroundColor = GeneralStyle.mainAppColor
    static let swipeElementImage = UIImage(systemName: "plus.circle.fill")
    static let swipeElementTitle = "Add to Favourite"
}

final class HomeView: UIViewController, HomeViewProtocol {
    var presenter: HomePresenterProtocol?
    let fatSearchProvider: FatSecretProviderProtocol
    let firebaseProvider: AuthenticationProviderProtocol
    
    private lazy var homeSearchView = HomeSearchView(fatSearchProvider: fatSearchProvider)
    private lazy var homeWelcomeView = HomeWelcomeView(firebaseProvider: firebaseProvider)
    
    private lazy var productCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var currentState: HomeState = .empty {
        didSet {
            updateViewStateAnimated()
        }
    }
    private let loadingView = AnimatedItem(animation: "loading", speed: 0.5)
    private let emptyView = AnimatedItem(animation: "emptyList", speed: 0.5)
    private var cancellables = Set<AnyCancellable>()
    private let animationDuration = HomeConstants.tappableAnimationDuration
    
    init(fatSearchProvider: FatSecretProviderProtocol, firebaseProvider: AuthenticationProviderProtocol) {
        self.fatSearchProvider = fatSearchProvider
        self.firebaseProvider = firebaseProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = GeneralStyle.mainBackgroundColor
        currentState = .empty
        setupSubviews()
        setupAutoLayout()
        disableBackNavigation()
        setupProductCell()
        setupBindings()
        addKeyboardHandler()
    }
}

private extension HomeView {
    func addKeyboardHandler() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func setupBindings() {
        homeSearchView.$ingredients
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ingredient in
                guard let self = self, let ingredient = ingredient else { return }
                self.handleIngredientUpdate(ingredient)
            }.store(in: &cancellables)
        
        homeSearchView.$searchBarText
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] input in
                self?.handleSearchBarTextUpdate(input)
            }.store(in: &cancellables)
    }
    
    func updateViewStateAnimated() {
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let self = self else { return }
            switch currentState {
            case .empty:
                self.emptyView.isHidden = false
                self.loadingView.isHidden = true
                self.productCollectionView.isHidden = true
                self.emptyView.play()
                self.loadingView.pause()
                
            case .loading:
                self.loadingView.isHidden = false
                self.emptyView.isHidden = true
                self.productCollectionView.isHidden = true
                self.loadingView.play()
                self.emptyView.pause()
                
            case .loaded:
                self.productCollectionView.isHidden = false
                self.emptyView.isHidden = true
                self.loadingView.isHidden = true
                self.loadingView.pause()
                self.emptyView.pause()
            }
        }
    }
    
    func handleSearchBarTextUpdate(_ input: String) {
        if input.isEmpty {
            homeSearchView.ingredients?.removeAll()
            currentState = .empty
        } else {
            currentState = .loading
        }
    }
    
    func handleIngredientUpdate(_ ingredient: [Food]?) {
        guard let ingredient = ingredient else { return }
        
        currentState = ingredient.isEmpty ? .empty : .loaded
        productCollectionView.reloadData()
    }
    
    func setupProductCell() {
        productCollectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
    }
    
    func callValidationAlert(with error: Error) {
        let alert = UIAlertController(title: HomeConstants.registrationAlertTitle, message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: HomeConstants.alertActionButton, style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func disableBackNavigation() {
        navigationItem.hidesBackButton = true
    }
    
    func setupSubviews() {
        view.addSubviewAndDisableAutoresizing(homeWelcomeView)
        view.addSubviewAndDisableAutoresizing(homeSearchView)
        view.addSubviewAndDisableAutoresizing(productCollectionView)
        view.addSubviewAndDisableAutoresizing(emptyView)
        view.addSubviewAndDisableAutoresizing(loadingView)
    }
    
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            homeWelcomeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeWelcomeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeWelcomeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeWelcomeView.heightAnchor.constraint(equalToConstant: HomeConstants.welcomeViewHeight),
            
            homeSearchView.topAnchor.constraint(equalTo: homeWelcomeView.bottomAnchor, constant: HomeConstants.welcomeViewTop),
            homeSearchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeSearchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            productCollectionView.topAnchor.constraint(equalTo: homeSearchView.bottomAnchor, constant: HomeConstants.productCollectionViewTop),
            productCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyView.topAnchor.constraint(equalTo: homeSearchView.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            emptyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            loadingView.topAnchor.constraint(equalTo: homeSearchView.bottomAnchor, constant: 20),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension HomeView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SwipeCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .drag
        return options
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right,
              let ingredients = self.homeSearchView.ingredients,
              let user = Auth.auth().currentUser,
              !ingredients.isEmpty else { return nil }
        
        let ingredient = ingredients[indexPath.row]
        
        let addToFavouriteAction = SwipeAction(style: .destructive, title: HomeConstants.swipeElementTitle) { [weak self] action, indexPath in
            self?.presenter?.saveIngredients(ingredient: ingredient, forUser: user.uid)
        }
        
        let addToCounterAction = SwipeAction(style: .destructive, title: HomeConstants.swipeElementTitle) { [weak self] action, indexPath in
            Task {
                try await self?.presenter?.getFood(by: ingredients[indexPath.row].foodId, userId: user.uid)
            }
        }
        
        addToCounterAction.backgroundColor = .yellow
        addToCounterAction.hidesWhenSelected = true
        
        addToFavouriteAction.backgroundColor = HomeConstants.swipeElementBackgroundColor
        addToFavouriteAction.image = HomeConstants.swipeElementImage
        addToFavouriteAction.hidesWhenSelected = true
        
        return [addToCounterAction, addToFavouriteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeSearchView.ingredients?.isEmpty ?? true ? HomeConstants.defaultAmountOfCells : homeSearchView.ingredients?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - HomeConstants.cellInsets, height: HomeConstants.productCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.alpha = 0
        if let ingredients = homeSearchView.ingredients, indexPath.row < ingredients.count {
            let ingredient = ingredients[indexPath.row]
            cell.configure(with: ingredient)
        } else {
            cell.configure(with: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: animationDuration) {
            cell.alpha = 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductCell,
              let ingredients = self.homeSearchView.ingredients,
              indexPath.row < ingredients.count else {
            return
        }
        let ingredient = ingredients[indexPath.row]
        cell.showAnimation {
            self.presenter?.openDetailedPage(with: ingredient.foodUrl)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
