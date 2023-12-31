//
//  HomePresenter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 19.08.2023.
//

import Foundation

protocol HomePresenterProtocol: AnyObject {
    var view: HomeViewProtocol? { get set }
    var interactor: HomeInteractorProtocol? { get set }
    var router: HomeRouterProtocol? { get set }
    
    func openDetailedPage(with id: String)
    func saveIngredients(ingredient: Food, forUser id: String)
}

final class HomePresenter: HomePresenterProtocol {    
    var view: HomeViewProtocol?
    var interactor: HomeInteractorProtocol?
    var router: HomeRouterProtocol?
    
    func openDetailedPage(with url: String) {
        router?.openDetailedPage(with: url)
    }
    
    func saveIngredients(ingredient: Food, forUser id: String) {
        interactor?.saveIngredients(ingredient: ingredient, forUser: id)
    }
}
