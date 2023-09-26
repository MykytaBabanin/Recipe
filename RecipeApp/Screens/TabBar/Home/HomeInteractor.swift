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
    var fatSecretProvider: FatSecretProviderProtocol? { get set }
    
    func save(ingredient: Food, forUser id: String)
    func getFood(by id: String, forUser userId: String) async throws
}

final class HomeInteractor: HomeInteractorProtocol {
    var presenter: HomePresenterProtocol?
    var firebaseDataProvider: FirebaseDataProviderProtocol?
    var fatSecretProvider: FatSecretProviderProtocol?
    
    func save(ingredient: Food, forUser id: String) {
        firebaseDataProvider?.save(ingredient: ingredient, forUser: id)
    }
    
    func getFood(by id: String, forUser userId: String) async throws {
        do {
            let fetchedFood = try await fatSecretProvider?.getFoodBy(id: id)
            if let fetchedFood = fetchedFood {
                firebaseDataProvider?.save(details: fetchedFood.food, forUser: userId)
            }
        }
    }
}
