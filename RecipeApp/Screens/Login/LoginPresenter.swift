//
//  Presenter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 07.08.2023.
//

import Foundation

final class LoginPresenter: Presentable {
    typealias ViewType = LoginView
    typealias InteractorType = LoginInteractor
    typealias RouterType = LoginRouter
    
    var view: ViewType?
    var interactor: InteractorType?
    var router: RouterType?
    
    func disableBackButton() {
        router?.disableBackButton()
    }
    
    func navigateRegistration() {
        router?.navigateRegistration()
    }
    
    func authenticate(username: String, password: String) {
        guard let authenticationResult = interactor?.authenticateUser(username: username, password: password) else { return }
        
        if authenticationResult.isEmpty {
            successfullAuthentication()
        } else {
            failureAuthentication(errors: authenticationResult)
        }
    }
    
    private func successfullAuthentication() {
        UserDefaults.standard.set(true, forKey: LoginConstants.isLoggedIn)
        view?.successfullyValidateFields()
        router?.navigateHome()
    }
    
    private func failureAuthentication(errors: [AuthenticationError]) {
        view?.checkValidation(errors)
    }
}
