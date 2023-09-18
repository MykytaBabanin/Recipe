//
//  CalorieCounterInteractor.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 18/09/2023.
//

import Foundation

protocol CalorieCounterInteractorProtocol {
    var presenter: CalorieCounterPresenterProtocol? { get set }
}

final class CalorieCounterInteractor: CalorieCounterInteractorProtocol {
    var presenter: CalorieCounterPresenterProtocol?
    
    
}
