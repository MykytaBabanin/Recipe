//
//  LoginConfigurator.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 13.08.2023.
//

import Foundation

final class LoginConfigurator {
    static let interactor = LoginInteractor()
    static let router = LoginRouter()
    static let presenter = LoginPresenter()
    static let view = LoginView()
    
    static func build() -> LoginView {
        return ModuleBuilder.build(view: view, presenter: presenter, interactor: interactor, router: router)
    }
}
