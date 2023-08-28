//
//  RegistrationInteractor.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 13.08.2023.
//

import Foundation
import FirebaseAuth

protocol RegistrationInteractorProtocol: AnyObject {
    var presenter: RegistrationPresenter? { get }
}

struct RegisteredUser {}

final class RegistrationInteractor {
    private let authenticationProvider: AuthenticationProviderProtocol
    
    init(authenticationProvider: AuthenticationProviderProtocol) {
        self.authenticationProvider = authenticationProvider
    }
    
    func createUser(email: String, password: String) async throws -> AuthDataResult {
        return try await authenticationProvider.signUp(email: email, password: password)
    }
}
