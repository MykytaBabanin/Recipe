//
//  Presenter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 07.08.2023.
//

import Foundation
import FirebaseAuth

protocol LoginPresenterProtocol {
    var view: LoginView? { get set }
    var interactor: LoginInteractorProtocol? { get set }
    var router: LoginRouterProtocol? { get set }
    
    func navigateRegistration()
    func authenticate(user: AuthorisedUser)
}

final class LoginPresenter: LoginPresenterProtocol {
    var view: LoginView?
    var interactor: LoginInteractorProtocol?
    var router: LoginRouterProtocol?
    
    init(view: LoginView? = nil, interactor: LoginInteractorProtocol? = nil, router: LoginRouterProtocol? = nil) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

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
                    self.failureAuthentication(errors: errors)
                }
            } catch {
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    self.view?.successfullyValidateFields()
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
