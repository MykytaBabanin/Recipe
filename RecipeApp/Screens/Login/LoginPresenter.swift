//
//  Presenter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 07.08.2023.
//

import Foundation
import FirebaseAuth

protocol LoginPresenterProtocol: AnyObject {
    var view: LoginViewProtocol? { get set }
    var interactor: LoginInteractorProtocol? { get set }
    var router: LoginRouterProtocol? { get set }
    
    func navigateRegistration()
    func authenticate(user: AuthorisedUser)
}

final class LoginPresenter: LoginPresenterProtocol {
    var view: LoginViewProtocol?
    var interactor: LoginInteractorProtocol?
    var router: LoginRouterProtocol?

    func navigateRegistration() {
        router?.navigateRegistration()
    }
    
    func authenticate(user: AuthorisedUser) {
        Task {
            do {
                try await interactor?.handleAuthentication(user: user)
                DispatchQueue.main.async {
                    self.successfullAuthentication()
                }
            } catch let errors as AuthenticationErrors {
                DispatchQueue.main.async {
                    self.failureFieldsValidation(errors: errors)
                }
            } catch {
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    self.failureAuthentication(error: error)
                }
            }
        }
    }
        
    private func successfullAuthentication() {
        UserDefaults.standard.set(true, forKey: LoginConstants.isLoggedIn)
        view?.successfullyValidateFields()
        router?.navigateHome()
    }
    
    private func failureAuthentication(error: Error) {
        view?.presentFailureAuthenticationAlert(with: error)
    }
    
    private func failureFieldsValidation(errors: AuthenticationErrors) {
        view?.checkValidation(errors)
    }
}
