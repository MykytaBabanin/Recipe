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
    func fetchIngredients(forUser id: String, completion: @escaping ([Food]) -> Void)
}

final class SavedInteractor: SavedInteractorProtocol {
    var presenter: SavedPresenterProtocol?
    
    func fetchIngredients(forUser id: String, completion: @escaping ([Food]) -> Void) {
        let database = Database.database(url: FirebaseConstants.databaseUrl)
        let userIngredientsRef = database.reference().child(FirebaseConstants.usersDirectory).child(id).child(FirebaseConstants.ingredientsDirectory)
        
        userIngredientsRef.observeSingleEvent(of: .value) { (snapshot) in
            var ingredients: [Food] = []
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let dict = childSnapshot.value as? [String: Any],
                   let name = dict[FirebaseConstants.nameField] as? String,
                   let url = dict[FirebaseConstants.urlField] as? String {
                    let ingredient = Food(foodId: "", foodName: name, foodUrl: url)
                    ingredients.append(ingredient)
                }
            }
            
            completion(ingredients)
        }
    }
}
