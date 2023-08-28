//
//  Interactor.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 07.08.2023.
//

import Foundation

enum AuthenticationError {
    case userNameError(String)
    case passwordError(String)
}

struct AuthenticationErrors: Error {
    let errors: [AuthenticationError]
}

struct AuthorisedUser {
    let userId: String
    let username: String
    let password: String
}

protocol LoginInteractorProtocol {
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
        let userResult = try await authenticationProvider.signIn(email: user.username, password: user.password)
        
        let authorisedUser = AuthorisedUser(userId: userResult.user.uid,
                                            username: userResult.user.email ?? "Unknown",
                                            password: user.password)
        print(authorisedUser)
    }
}

private extension LoginInteractor {
    func validateCredentials(user: AuthorisedUser) -> [AuthenticationError] {
        var errors: [AuthenticationError] = []
        
        if !user.username.isEmailValid() {
            errors.append(.userNameError(user.username.validateEmail()))
        }
        
        if !user.password.isPasswordValid() {
            errors.append(.passwordError(user.password.validatePassword()))
        }
        
        return errors
    }
}
