//
//  FirebaseAuthenticationProvider.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 22.08.2023.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

enum FirebaseConstants {
    static let databaseUrl = "https://recipeapp-3cbe4-default-rtdb.europe-west1.firebasedatabase.app/"
    static let usersDirectory = "users"
    static let ingredientsDirectory = "ingredients"
    static let foodId = "foodId"
    static let nameField = "name"
    static let urlField = "url"
}

protocol AuthenticationProviderProtocol: AnyObject {
    func fetchUsername() -> String
    func signIn(email: String, password: String) async throws -> AuthDataResult
    func signUp(username: String, email: String, password: String) async throws -> AuthDataResult
}

protocol FirebaseDataProviderProtocol: AnyObject {
    func saveIngredients(ingredient: Food, forUser id: String)
    func fetchIngredients(forUser id: String, completion: @escaping ([Food]) -> Void)
    func removeIngredient(ingredient: Food, forUser id: String)
}

final class FirebaseAuthenticationProvider: AuthenticationProviderProtocol {
    func signIn(email: String, password: String) async throws -> AuthDataResult {
        try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let result = result {
                    continuation.resume(returning: result)
                }
            }
        }
    }
    
    func signUp(username: String, email: String, password: String) async throws -> AuthDataResult {
        try await withCheckedThrowingContinuation { continuation in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let result = result {
                    let changeRequest = result.user.createProfileChangeRequest()
                    changeRequest.displayName = username
                    changeRequest.commitChanges { error in
                        if let error = error {
                            continuation.resume(throwing: error)
                        }
                    }
                    continuation.resume(returning: result)
                }
            }
        }
    }
    
    func fetchUsername() -> String {
        guard let username = Auth.auth().currentUser?.displayName else { return "" }
        return username
    }
}

final class FirebaseDataProvider: FirebaseDataProviderProtocol {
    func saveIngredients(ingredient: Food, forUser id: String) {
        let database = Database.database(url: FirebaseConstants.databaseUrl)
        let userIngredientsRef = database.reference().child(FirebaseConstants.usersDirectory).child(id).child(FirebaseConstants.ingredientsDirectory).child(ingredient.foodId)
        userIngredientsRef.setValue([
            FirebaseConstants.foodId: ingredient.foodId,
            FirebaseConstants.nameField: ingredient.foodName,
            FirebaseConstants.urlField: ingredient.foodUrl
        ])
    }
    
    func fetchIngredients(forUser id: String, completion: @escaping ([Food]) -> Void) {
        let database = Database.database(url: FirebaseConstants.databaseUrl)
        let userIngredientsRef = database.reference().child(FirebaseConstants.usersDirectory).child(id).child(FirebaseConstants.ingredientsDirectory)
        
        userIngredientsRef.observeSingleEvent(of: .value) { (snapshot) in
            var ingredients: [Food] = []
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let dict = childSnapshot.value as? [String: Any],
                   let foodId = dict[FirebaseConstants.foodId] as? String,
                   let name = dict[FirebaseConstants.nameField] as? String,
                   let url = dict[FirebaseConstants.urlField] as? String {
                    let ingredient = Food(foodId: foodId, foodName: name, foodUrl: url)
                    ingredients.append(ingredient)
                }
            }
            
            completion(ingredients)
        }
    }
    
    func removeIngredient(ingredient: Food, forUser id: String) {
        let database = Database.database(url: FirebaseConstants.databaseUrl)
        let userIngredientsRef = database.reference().child(FirebaseConstants.usersDirectory).child(id).child(FirebaseConstants.ingredientsDirectory).child(ingredient.foodId)
        userIngredientsRef.removeValue()
    }
}
