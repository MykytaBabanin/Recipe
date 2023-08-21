//
//  LoginConfigurator.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 13.08.2023.
//

import Foundation

final class LoginConfigurator {
    static func build() -> LoginView {
        let interactor = LoginInteractor()
        let router = LoginRouter()
        let presenter = LoginPresenter()
        let view = LoginView()
        
        return ModuleBuilder.build(view: view, presenter: presenter, interactor: interactor, router: router)
    }
}
