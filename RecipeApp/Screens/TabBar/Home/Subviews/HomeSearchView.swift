//
//  HomeSearchView.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 31.08.2023.
//

import UIKit
import Combine

final class HomeSearchView: UIView, UISearchBarDelegate {
    enum SearchConstants {
        static let magnifyingGlassIcon = "magnifyingglass"
        static let empty = ""
        static let failedToDecodeMessage = "We encountered an empty search. Please fill the input to see the resulted products"
        static let alertTitle = "Error"
        static let alertAction = "Ok"
        static let verticalInsets: CGFloat = 10
        static let buttonSize: CGFloat = 50
        static let buttonTrailingAnchor: CGFloat = 20
    }
    
    @Published var ingredients: [Food]?
    @Published var searchBarText = SearchConstants.empty

    private let fatSearchProvider: FatSecretProviderProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        Home.SearchBar.apply(searchBar)
        return searchBar
    }()
    
    private lazy var applyButton: UIButton = {
        let filterButton = UIButton()
        Home.Button.apply(filterButton)
        filterButton.setImage(UIImage(systemName: SearchConstants.magnifyingGlassIcon)?.withTintColor(.white).withRenderingMode(.alwaysOriginal), for: .normal)
        return filterButton
    }()
    
    init(fatSearchProvider: FatSecretProviderProtocol) {
        self.fatSearchProvider = fatSearchProvider
        super.init(frame: .zero)
        setupSubview()
        setupAutoLayout()
        setupBindings()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarText = searchText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeSearchView {
    func setupBindings() {
        applyButton.touchUpInsidePublisher()
            .sink { [weak self] in
                guard let self = self else { return }
                Task {
                    self.showAnimation {
                        self.fatSearchProvider.key = FatSecret.apiKey
                        self.fatSearchProvider.secret = FatSecret.apiSecret
                        self.fatSearchProvider.searchFoodBy(name: self.searchBar.text ?? SearchConstants.empty, completion: { result in
                            switch result {
                            case .success(let fetchedFood):
                                self.ingredients = self.uniqueIngredients(fetchedFood: fetchedFood)
                            case .failure(let error):
                                self.callAlert(with: error)
                            }
                        })
                    }
                }
            }.store(in: &subscriptions)
    }
    
    func uniqueIngredients(fetchedFood: FoodSearch) -> [Food]? {
        let uniqueIngredientsDictionary = Dictionary(grouping: fetchedFood.foods.food, by: { $0.foodName })
        let uniqueIngredientsArray = uniqueIngredientsDictionary.values
        return uniqueIngredientsArray.compactMap { $0.first }
    }
    
    func callAlert(with error: FatSecretError) {
        DispatchQueue.main.async {
            if let viewController = self.findViewController() {
                let message: String
                switch error {
                case .failedToDecode:
                    message = SearchConstants.failedToDecodeMessage
                case .failedToRetrieveData:
                    message = SearchConstants.empty
                case .invalidURL:
                    message = SearchConstants.empty
                    
                }
                let alert = UIAlertController(title: SearchConstants.alertTitle, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: SearchConstants.alertAction, style: .default, handler: nil))
                viewController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func setupSubview() {
        searchBar.delegate = self
        addSubviewAndDisableAutoresizing(searchBar)
        addSubviewAndDisableAutoresizing(applyButton)
    }
    
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SearchConstants.verticalInsets),
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.trailingAnchor.constraint(equalTo: applyButton.leadingAnchor, constant: -SearchConstants.verticalInsets),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            applyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SearchConstants.buttonTrailingAnchor),
            applyButton.widthAnchor.constraint(equalToConstant: SearchConstants.buttonSize),
            applyButton.heightAnchor.constraint(equalToConstant: SearchConstants.buttonSize)
        ])
    }
}

