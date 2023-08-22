//
//  Presenter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 07.08.2023.
//

import Foundation
import FirebaseAuth

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
    
    func authenticate(email: String, password: String) {
        Task {
            do {
                guard let result = try await interactor?.handleAuthentication(username: email, password: password) else { return }
                DispatchQueue.main.async {
                    self.successfullAuthentication()
                }
            } catch let errors as AuthenticationErrors {
                DispatchQueue.main.async {
                    self.failureAuthentication(errors: errors)
                }
            }
        }
    }
        
    private func successfullAuthentication() {
        UserDefaults.standard.set(true, forKey: LoginConstants.isLoggedIn)
        view?.successfullyValidateFields()
        router?.navigateHome()
    }
    
    private func failureAuthentication(errors: AuthenticationErrors) {
        view?.checkValidation(errors)
    }
}
