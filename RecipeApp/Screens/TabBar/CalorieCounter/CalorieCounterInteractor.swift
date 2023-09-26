//
//  CalorieCounterInteractor.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 18/09/2023.
//

import Foundation

protocol CalorieCounterInteractorProtocol {
    var presenter: CalorieCounterPresenterProtocol? { get set }
    var firebaseDataProvider: FirebaseDataProviderProtocol? { get set }
    
    func fetchIngredients(forUser id: String, completion: @escaping ([FirebaseFoodResponse]) -> Void)
}

final class CalorieCounterInteractor: CalorieCounterInteractorProtocol {
    var presenter: CalorieCounterPresenterProtocol?
    var firebaseDataProvider: FirebaseDataProviderProtocol?
    
    func fetchIngredients(forUser id: String, completion: @escaping ([FirebaseFoodResponse]) -> Void) {
        firebaseDataProvider?.fetchIngredientsById(forUser: id, completion: completion)
    }
}
