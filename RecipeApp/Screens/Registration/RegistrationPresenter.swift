//
//  RegistrationPresenter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 13.08.2023.
//

import Foundation

protocol RegistrationPresenterProtocol {
    var view: RegistrationView? { get }
    var interactor: RegistrationInteractor? { get }
    var router: RegistrationRouter? { get }
    
    func registerUser(email: String, password: String) async -> Bool
    func navigateLogin()
}

final class RegistrationPresenter: RegistrationPresenterProtocol {
    var view: RegistrationView?
    var interactor: RegistrationInteractor?
    var router: RegistrationRouter?
    
    func registerUser(email: String, password: String) async -> Bool {
        do {
            _ = try await interactor?.createUser(email: email, password: password)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func navigateLogin() {
        router?.navigateLogin()
    }
}
