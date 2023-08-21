//
//  Interactor.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 07.08.2023.
//

import Foundation

enum AuthenticationError {
    case userNameError
    case passwordError
}

final class LoginInteractor: Interactable {
    typealias PresenterType = LoginPresenter
    
    var presenter: PresenterType?
    
    func authenticateUser(username: String, password: String) -> [AuthenticationError]? {
        var errors: [AuthenticationError] = []
        
        if isValidUsername(username: username) {
            errors.append(.userNameError)
        }
        
        if isValidPassword(password: password) {
            errors.append(.passwordError)
        }
        
        return errors
    }
    
    private func isValidUsername(username: String) -> Bool {
        return username.count < 4
    }
    
    private func isValidPassword(password: String) -> Bool {
        return password.count < 8
    }
}
