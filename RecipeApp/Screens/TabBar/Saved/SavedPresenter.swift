//
//  SavedPresenter.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 11/09/2023.
//

import Foundation
import FirebaseAuth

protocol SavedPresenterProtocol: AnyObject {
    var router: SavedRouterProtocol? { get set }
    var interactor: SavedInteractorProtocol? { get set }
    var view: SavedViewProtocol? { get set }
    var ingredients: [Food]? { get set }
    var ingredientsPublisher: Published<[Food]?>.Publisher { get }
    
    func openDetailedPage(with url: String)
    func fetchIngredients()
}

final class SavedPresenter: SavedPresenterProtocol {
    var router: SavedRouterProtocol?
    var interactor: SavedInteractorProtocol?
    var view: SavedViewProtocol?
    
    @Published var ingredients: [Food]?
    
    var ingredientsPublisher: Published<[Food]?>.Publisher {
        $ingredients
    }
    
    func fetchIngredients() {
        if let user = Auth.auth().currentUser {
            interactor?.fetchIngredients(forUser: user.uid, completion: { [weak self] ingredients in
                self?.ingredients = ingredients
            })
        }
    }
    
    func openDetailedPage(with url: String) {
        router?.openDetailedPage(with: url)
    }
}
