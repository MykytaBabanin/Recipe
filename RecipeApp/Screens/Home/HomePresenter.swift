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
    
    func openFilterSearchView()
}

final class HomePresenter: HomePresenterProtocol {    
    var view: HomeViewProtocol?
    var interactor: HomeInteractorProtocol?
    var router: HomeRouterProtocol?
    
    func openFilterSearchView() {
        router?.openFilterSearchView()
    }
}
