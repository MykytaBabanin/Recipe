//
//  RegistrationInteractor.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 13.08.2023.
//

import Foundation
import FirebaseAuth

enum RegistrationError {
    case username(String)
    case email(String)
    case password(String)
    case confirmationPassword(String)
}

struct RegistrationErrors: Error {
    let errors: [RegistrationError]
}

protocol RegistrationInteractorProtocol: AnyObject {
    var presenter: RegistrationPresenterProtocol? { get set }
    func handleRegistration(user: RegisteredUser) async throws
}

struct RegisteredUser {
    let username: String
    let email: String
    let password: String
    let confirmationPassword: String
}

final class RegistrationInteractor: RegistrationInteractorProtocol {
    var presenter: RegistrationPresenterProtocol?
    private let authenticationProvider: AuthenticationProviderProtocol
    
    init(authenticationProvider: AuthenticationProviderProtocol) {
        self.authenticationProvider = authenticationProvider
    }
    
    func handleRegistration(user: RegisteredUser) async throws {
        let validationErrors = validateCredentials(user: user)
        
        guard validationErrors.isEmpty else {
            throw RegistrationErrors(errors: validationErrors)
        }
        
        try await authenticationProvider.signUp(username: user.username, email: user.email, password: user.password)
    }
    
    private func validateCredentials(user: RegisteredUser) -> [RegistrationError] {
        var errors: [RegistrationError] = []
        
        if !user.email.isEmailValid() {
            errors.append(.email(user.email.validateEmail()))
        }
        
        if !user.username.isUsernameValid() {
            errors.append(.username(user.username.validateUsername()))
        }
        
        if !user.password.isPasswordValid() {
            errors.append(.password(user.password.validatePassword()))
        }
    
        return errors
    }
}
