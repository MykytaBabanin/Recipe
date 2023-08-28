//
//  RegistrationConfigurator.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 13.08.2023.
//

import Foundation

final class RegistrationConfigurator {
    static func build() -> RegistrationViewProtocol {
        let view: RegistrationViewProtocol = RegistrationView()
        let authenticationProvider = FirebaseAuthenticationProvider()
        let interactor: RegistrationInteractorProtocol = RegistrationInteractor(authenticationProvider: authenticationProvider)
        let router: RegistrationRouterProtocol = RegistrationRouter()
        let presenter: RegistrationPresenterProtocol = RegistrationPresenter()
        
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        interactor.presenter = presenter
        
        router.view = view
        
        return view
    }
}
