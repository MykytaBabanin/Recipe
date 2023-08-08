//
//  WelcomeConfigurator.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 11.08.2023.
//

import Foundation

final class WelcomeConfigurator {
    static func build() -> WelcomeView {
        let view = WelcomeView()
        let presenter = WelcomePresenter()
        let interactor = WelcomeInteractor()
        let router = WelcomeRouter()
        
        return ModuleBuilder.build(view: view, presenter: presenter, interactor: interactor, router: router)
    }
}
