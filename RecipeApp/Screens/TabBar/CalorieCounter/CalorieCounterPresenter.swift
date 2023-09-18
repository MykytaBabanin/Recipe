//
//  CalorieCounterPresenter.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 18/09/2023.
//

import Foundation

protocol CalorieCounterPresenterProtocol {
    var interactor: CalorieCounterInteractorProtocol? { get set }
    var view: CalorieCounterViewProtocol? { get set }
    var router: CalorieCounterRouterProtocol? { get set }
}

final class CalorieCounterPresenter: CalorieCounterPresenterProtocol {
    var interactor: CalorieCounterInteractorProtocol?
    
    var view: CalorieCounterViewProtocol?
    
    var router: CalorieCounterRouterProtocol?
    
    
}
