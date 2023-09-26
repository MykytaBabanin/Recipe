//
//  SavedInteractor.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 11/09/2023.
//

import Foundation
import FirebaseDatabase

protocol SavedInteractorProtocol: AnyObject {
    var presenter: SavedPresenterProtocol? { get set }
    var firebaseDataProvider: FirebaseDataProviderProtocol? { get set }
    
    func fetchIngredients(forUser id: String, completion: @escaping ([Food]) -> Void)
    func removeIngredient(ingredient: Food, forUser id: String)
}

final class SavedInteractor: SavedInteractorProtocol {
    var presenter: SavedPresenterProtocol?
    var firebaseDataProvider: FirebaseDataProviderProtocol?
    
    func fetchIngredients(forUser id: String, completion: @escaping ([Food]) -> Void) {
        firebaseDataProvider?.fetchIngredients(forUser: id, completion: completion)
    }
    
    func removeIngredient(ingredient: Food, forUser id: String) {
        firebaseDataProvider?.remove(ingredient: ingredient, forUser: id)
    }
}
