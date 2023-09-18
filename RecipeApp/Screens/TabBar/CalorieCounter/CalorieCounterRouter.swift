//
//  CalorieCounterRouter.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 18/09/2023.
//

import Foundation

protocol CalorieCounterRouterProtocol {
    var view: CalorieCounterViewProtocol? { get set }
}

final class CalorieCounterRouter: CalorieCounterRouterProtocol {
    var view: CalorieCounterViewProtocol?
    
    
}
