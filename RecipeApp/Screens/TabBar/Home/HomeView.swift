//
//  HomeView.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 19.08.2023.
//

import UIKit
import Combine
import FirebaseAuth

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
        setupSubviews()
        setupAutoLayout()
        disableBackNavigation()
        setupProductCell()
        setupBindings()
    }
}

private extension HomeView {
    func setupBindings() {
        homeSearchView.$ingredients
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.productCollectionView.reloadData()
            }.store(in: &cancellables)
        
        homeSearchView.$searchBarText
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] input in
                if input.isEmpty {
                    self?.homeSearchView.ingredients?.removeAll()
                    self?.productCollectionView.reloadData()
                }
            }.store(in: &cancellables)
    }
    
    func setupProductCell() {
        productCollectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
    }
    
    private func callValidationAlert(with error: Error) {
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
            productCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension HomeView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeSearchView.ingredients?.isEmpty ?? true ? HomeConstants.defaultAmountOfCells : homeSearchView.ingredients?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - HomeConstants.productCellWidthIset, height: HomeConstants.productCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        
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
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProductCell else { return }
        cell.showAnimation {
            if let ingredient = self.homeSearchView.ingredients?[indexPath.row] {
                if let user = Auth.auth().currentUser {
                    self.presenter?.saveIngredients(ingredient: ingredient, forUser: user.uid)
                }
                self.presenter?.openDetailedPage(with: ingredient.foodUrl)
            }
        }
    }
}
