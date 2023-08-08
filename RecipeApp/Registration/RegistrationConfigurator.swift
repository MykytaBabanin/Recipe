//
//  RegistrationConfigurator.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 13.08.2023.
//

import Foundation

final class RegistrationConfigurator {
    static func build() -> RegistrationView {
        let view = RegistrationView()
        let presenter = RegistrationPresenter()
        let interactor = RegistrationInteractor()
        let router = RegistrationRouter()
        
        return ModuleBuilder.build(view: view, presenter: presenter, interactor: interactor, router: router)
    }
}
