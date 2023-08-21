//
//  Presenter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 07.08.2023.
//

import Foundation

class LoginPresenter: Presentable {
    typealias ViewType = LoginView
    typealias InteractorType = LoginInteractor
    typealias RouterType = LoginRouter
    
    var view: ViewType?
    var interactor: InteractorType?
    var router: RouterType?
    
    func navigateRegistration() {
        router?.navigateRegistration()
    }
    
    func authenticate(username: String, password: String) {
        guard let interactor = interactor else { return }
        if interactor.authenticateUser(username: username, password: password) {
            router?.navigateHome()
        } else {
            view?.showError(Error.invalidCredentials)
        }
    }
}
