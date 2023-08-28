//
//  RegistrationPresenter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 13.08.2023.
//

import Foundation

protocol RegistrationPresenterProtocol: AnyObject {
    var view: RegistrationViewProtocol? { get set }
    var interactor: RegistrationInteractorProtocol? { get set }
    var router: RegistrationRouterProtocol? { get set }
    
    func navigateLogin()
    func register(user: RegisteredUser)
}

final class RegistrationPresenter: RegistrationPresenterProtocol {
    var view: RegistrationViewProtocol?
    var interactor: RegistrationInteractorProtocol?
    var router: RegistrationRouterProtocol?
    
    func register(user: RegisteredUser) {
        Task {
            do {
                try await interactor?.handleRegistration(user: user)
                DispatchQueue.main.async {
                    self.successfullAuthentication()
                }
            } catch let errors as RegistrationErrors {
                DispatchQueue.main.async {
                    self.failureAuthentication(errors: errors)
                }
            } catch {
                DispatchQueue.main.async {
                    self.view?.successfullyValidateFields(error: error)
                }
            }
        }
    }
    
    private func successfullAuthentication() {
        view?.successfullyValidateFields(error: nil)
        router?.navigateLogin()
    }
    
    private func failureAuthentication(errors: RegistrationErrors) {
        view?.checkValidation(errors)
    }
    
    func navigateLogin() {
        router?.navigateLogin()
    }
}
