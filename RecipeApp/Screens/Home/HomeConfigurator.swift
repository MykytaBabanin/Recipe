//
//  HomeConfigurator.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 19.08.2023.
//

import Foundation

final class HomeConfigurator {
    static func build() -> HomeView {
        let authenticationProvider = FirebaseAuthenticationProvider()
        let interactor = HomeInteractor(authenticationProvider: authenticationProvider)
        
        let router = HomeRouter()
        let presenter = HomePresenter()
        let view = HomeView()
        
        return ModuleBuilder.build(view: view, presenter: presenter, interactor: interactor, router: router)
    }
}

