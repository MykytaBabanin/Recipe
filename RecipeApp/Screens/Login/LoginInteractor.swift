//
//  Interactor.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 07.08.2023.
//

import Foundation
import FirebaseAuth

enum AuthenticationError {
    case userNameError
    case passwordError
}

struct AuthenticationErrors: Error {
    let errors: [AuthenticationError]
}

final class LoginInteractor: Interactable {
    var authenticationProvider: AuthenticationProviderProtocol
    typealias PresenterType = LoginPresenter
    
    var presenter: PresenterType?
    
    init(authenticationProvider: AuthenticationProviderProtocol) {
        self.authenticationProvider = authenticationProvider
    }
    
    func handleAuthentication(username: String, password: String) async throws -> AuthDataResult {
        let errors = validateCredentials(username: username, password: password)
        
        guard errors.isEmpty else {
            throw AuthenticationErrors(errors: errors)
        }
        
        return try await authenticationProvider.signIn(email: username, password: password)
    }
    
    func validateCredentials(username: String, password: String) -> [AuthenticationError] {
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
