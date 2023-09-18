//
//  Interactor.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 07.08.2023.
//

import Foundation

enum AuthenticationError {
    case username(String)
    case password(String)
}

struct AuthenticationErrors: Error {
    let errors: [AuthenticationError]
}

struct AuthorisedUser {
    let userId: String
    let username: String
    let password: String
}

protocol LoginInteractorProtocol: AnyObject {
    var presenter: LoginPresenterProtocol? { get set }
    func handleAuthentication(user: AuthorisedUser) async throws
}

final class LoginInteractor: LoginInteractorProtocol {
    private let authenticationProvider: AuthenticationProviderProtocol
    
    var presenter: LoginPresenterProtocol?
    
    init(authenticationProvider: AuthenticationProviderProtocol, presenter: LoginPresenterProtocol) {
        self.authenticationProvider = authenticationProvider
        self.presenter = presenter
    }
    
    func handleAuthentication(user: AuthorisedUser) async throws {
        let validationErrors = validateCredentials(user: user)
        
        guard validationErrors.isEmpty else {
            throw AuthenticationErrors(errors: validationErrors)
        }
        
        try await authenticationProvider.signIn(email: user.username, password: user.password)
    }
}

private extension LoginInteractor {
    func validateCredentials(user: AuthorisedUser) -> [AuthenticationError] {
        var errors: [AuthenticationError] = []
        
        if !user.username.isEmailValid() {
            errors.append(.username(user.username.validateEmail()))
        }
        
        if !user.password.isPasswordValid() {
            errors.append(.password(user.password.validatePassword()))
        }
        
        return errors
    }
}
