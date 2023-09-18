//
//  HomeInteractor.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 19.08.2023.
//

import Foundation
import Firebase

protocol HomeInteractorProtocol: AnyObject {
    var presenter: HomePresenterProtocol? { get set }
    var firebaseDataProvider: FirebaseDataProviderProtocol? { get set }
    
    func saveIngredients(ingredient: Food, forUser id: String)
}

final class HomeInteractor: HomeInteractorProtocol {    
    var presenter: HomePresenterProtocol?
    var firebaseDataProvider: FirebaseDataProviderProtocol?
    
    func saveIngredients(ingredient: Food, forUser id: String) {
        firebaseDataProvider?.saveIngredients(ingredient: ingredient, forUser: id)
    }
}
