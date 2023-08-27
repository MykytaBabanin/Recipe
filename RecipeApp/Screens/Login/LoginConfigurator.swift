//
//  LoginConfigurator.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 13.08.2023.
//

import Foundation

final class LoginConfigurator {
    static func build() -> LoginView {
        let authenticationProvider = FirebaseAuthenticationProvider()
        var presenter: LoginPresenterProtocol = LoginPresenter()
        let interactor = LoginInteractor(authenticationProvider: authenticationProvider, presenter: presenter)
        let view = LoginView()
        var router: LoginRouterProtocol = LoginRouter(view: view)
        
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        interactor.presenter = presenter
        
        router.view = view
        
        return view
    }
}
