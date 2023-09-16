//
//  HomeConfigurator.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 19.08.2023.
//

import UIKit

final class TabBarConfigurator {
    static func build() -> HomeTabBarProtocol {
        let router: HomeRouterProtocol = HomeRouter()
        let view: HomeTabBarProtocol = HomeTabBarController()
        let interactor: HomeInteractorProtocol = HomeInteractor()
        let presenter: HomePresenterProtocol = HomePresenter()
                
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
                
        return view
    }
}

