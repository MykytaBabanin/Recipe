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
    static let foodId = "food_id"
    static let nameField = "food_name"
    static let foodType = "food_type"
    static let urlField = "food_url"
    static let serving = "servings"
}

protocol AuthenticationProviderProtocol: AnyObject {
    func fetchUsername() -> String
    func signIn(email: String, password: String) async throws -> AuthDataResult
    func signUp(username: String, email: String, password: String) async throws -> AuthDataResult
}

protocol FirebaseDataProviderProtocol: AnyObject {
    func save(ingredient: Food, forUser id: String)
    func save(details: FoodDetails, forUser id: String)
    func fetchIngredients(forUser id: String, completion: @escaping ([Food]) -> Void)
    func fetchIngredientsById(forUser id: String, completion: @escaping ([FirebaseFoodResponse]) -> Void)
    func remove(ingredient: Food, forUser id: String)
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
    func save(ingredient: Food, forUser id: String) {
        let database = Database.database(url: FirebaseConstants.databaseUrl)
        let userIngredientsRef = database.reference().child(FirebaseConstants.usersDirectory).child(id).child(FirebaseConstants.ingredientsDirectory).child(ingredient.foodId)
        userIngredientsRef.setValue([
            FirebaseConstants.foodId: ingredient.foodId,
            FirebaseConstants.nameField: ingredient.foodName,
            FirebaseConstants.urlField: ingredient.foodUrl
        ])
    }
    
    func save(details: FoodDetails, forUser id: String) {
        let database = Database.database(url: FirebaseConstants.databaseUrl)
        let userIngredientsRef = database.reference().child(FirebaseConstants.usersDirectory).child(id).child(FirebaseConstants.ingredientsDirectory).child("\(details.foodId)")
        let servingDictionaries = convertServingsToDictionaries(servings: details.servings.serving ?? details.servings.servingDictionary)
        userIngredientsRef.setValue([
            FirebaseConstants.foodId: details.foodId,
            FirebaseConstants.nameField: details.foodName,
            FirebaseConstants.urlField: details.foodUrl,
            FirebaseConstants.foodType: details.foodType,
            FirebaseConstants.serving: servingDictionaries
        ])
    }

    
    func convertServingsToDictionaries(servings: Any) -> Any {
        let encoder = JSONEncoder()
        let jsonData: Data?
        if let singleServing = servings as? Serving {
            jsonData = try! encoder.encode(singleServing)
        } else if let multipleServings = servings as? [Serving] {
            jsonData = try! encoder.encode(multipleServings)
        } else {
            return []
        }

        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData!, options: [])
            
            if let dictionaryArray = jsonObject as? [[String: Any]] {
                return dictionaryArray
            } else if let dictionary = jsonObject as? [String: Any] {
                return [dictionary]
            } else {
                return []
            }
        } catch {
            print("Error serializing JSON: \(error)")
            return []
        }
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
    
    func fetchIngredientsById(forUser id: String, completion: @escaping ([FirebaseFoodResponse]) -> Void) {
        let database = Database.database(url: FirebaseConstants.databaseUrl)
        let userIngredientsRef = database.reference().child(FirebaseConstants.usersDirectory).child(id).child(FirebaseConstants.ingredientsDirectory)

        userIngredientsRef.observeSingleEvent(of: .value) { (snapshot) in
            var ingredients: [FirebaseFoodResponse] = []

            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let dict = childSnapshot.value as? [String: Any] {
                       do {
                           let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
                           let decoder = JSONDecoder()
                           print(dict)
                           let ingredient = try decoder.decode(FirebaseFoodResponse.self, from: jsonData)

                           ingredients.append(ingredient)
                       } catch let DecodingError.typeMismatch(type, context)  {
                           print("Type mismatch: \(type), context: \(context)")
                       } catch let DecodingError.valueNotFound(value, context) {
                           print("Value not found: \(value), context: \(context)")
                       } catch let DecodingError.keyNotFound(key, context) {
                           print("Key not found: \(key), context: \(context)")
                       } catch let DecodingError.dataCorrupted(context) {
                           print("Data corrupted: \(context)")
                       } catch let error {
                           print(error)
                       }
                }
            }

            completion(ingredients)
        }
    }
    
    func remove(ingredient: Food, forUser id: String) {
        let database = Database.database(url: FirebaseConstants.databaseUrl)
        let userIngredientsRef = database.reference().child(FirebaseConstants.usersDirectory).child(id).child(FirebaseConstants.ingredientsDirectory).child(ingredient.foodId)
        userIngredientsRef.removeValue()
    }
}
