//
//  LoginConfigurator.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 13.08.2023.
//

import Foundation

final class LoginConfigurator {
    static func build() -> LoginViewProtocol {
        let authenticationProvider = FirebaseAuthenticationProvider()
        let presenter: LoginPresenterProtocol = LoginPresenter()
        let interactor = LoginInteractor(authenticationProvider: authenticationProvider, presenter: presenter)
        let view: LoginViewProtocol = LoginView()
        let router: LoginRouterProtocol = LoginRouter()
        
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        interactor.presenter = presenter
        
        router.view = view
        
        return view
    }
}
