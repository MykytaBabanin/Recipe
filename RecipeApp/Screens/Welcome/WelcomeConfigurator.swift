//
//  WelcomeConfigurator.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 11.08.2023.
//

import Foundation

final class WelcomeConfigurator {
    static func build() -> WelcomeView {
        let authenticationProvider = FirebaseAuthenticationProvider()
        let interactor = WelcomeInteractor(authenticationProvider: authenticationProvider)
        
        let view = WelcomeView()
        let presenter = WelcomePresenter()
        let router = WelcomeRouter()
        
        return ModuleBuilder.build(view: view, presenter: presenter, interactor: interactor, router: router)
    }
}
