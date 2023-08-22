//
//  RegistrationPresenter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 13.08.2023.
//

import Foundation

final class RegistrationPresenter: Presentable {
    typealias ViewType = RegistrationView
    typealias InteractorType = RegistrationInteractor
    typealias RouterType = RegistrationRouter
    
    var view: ViewType?
    var interactor: InteractorType?
    var router: RouterType?
    
    func registerUser(email: String, password: String) async -> Bool {
        do {
            _ = try await interactor?.createUser(email: email, password: password)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func disableBackButton() {
        router?.disableBackButton()
    }
    
    func navigateLogin() {
        router?.navigateLogin()
    }
}
