//
//  HomeConfigurator.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 19.08.2023.
//

import Foundation

final class HomeConfigurator {
    static func build() -> HomeViewProtocol {
        let router: HomeRouterProtocol = HomeRouter()
        let view: HomeViewProtocol = HomeView()
        let interactor: HomeInteractorProtocol = HomeInteractor()
        let presenter: HomePresenterProtocol = HomePresenter()
        
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        interactor.presenter = presenter
        
        router.view = view
        

        return view
    }
}

