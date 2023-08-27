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
        let validationErrors = validateCredentials(username: user.username, password: user.password)
        
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
    func validateCredentials(username: String, password: String) -> [AuthenticationError] {
        var errors: [AuthenticationError] = []
        
        if !isValidUsername(username: username) {
            errors.append(.userNameError)
        }
        
        if !isValidPassword(password: password) {
            errors.append(.passwordError)
        }
        
        return errors
    }
    
    func isValidUsername(username: String) -> Bool {
        return username.validateEmail()
    }
    
    func isValidPassword(password: String) -> Bool {
        return password.validatePassword()
    }
}
