//
//  CalorieCounterPresenter.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 18/09/2023.
//

import Foundation
import FirebaseAuth

protocol CalorieCounterPresenterProtocol {
    var interactor: CalorieCounterInteractorProtocol? { get set }
    var view: CalorieCounterViewProtocol? { get set }
    var router: CalorieCounterRouterProtocol? { get set }
    var ingredients: [FirebaseFoodResponse]? { get set }
    var ingredientsPublisher: Published<[FirebaseFoodResponse]?>.Publisher { get }
    
    func fetchIngredients()
}

final class CalorieCounterPresenter: CalorieCounterPresenterProtocol {
    var interactor: CalorieCounterInteractorProtocol?
    var view: CalorieCounterViewProtocol?
    var router: CalorieCounterRouterProtocol?
    
    @Published var ingredients: [FirebaseFoodResponse]?
    
    var ingredientsPublisher: Published<[FirebaseFoodResponse]?>.Publisher {
        $ingredients
    }
    
    func fetchIngredients() {
        if let user = Auth.auth().currentUser {
            interactor?.fetchIngredients(forUser: user.uid, completion: { [weak self] ingredients in
                self?.ingredients = ingredients
            })
        }
    }
}
