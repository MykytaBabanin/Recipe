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
    
    func saveIngredients(ingredient: Food, forUser id: String)
}

final class HomeInteractor: HomeInteractorProtocol {    
    var presenter: HomePresenterProtocol?
    
    func saveIngredients(ingredient: Food, forUser id: String) {
        let database = Database.database(url: FirebaseConstants.databaseUrl)
        let userIngredientsRef = database.reference().child(FirebaseConstants.usersDirectory).child(id).child(FirebaseConstants.ingredientsDirectory).child(ingredient.foodId)
        userIngredientsRef.setValue([
            FirebaseConstants.nameField: ingredient.foodName,
            FirebaseConstants.urlField: ingredient.foodUrl
        ])
    }
}
