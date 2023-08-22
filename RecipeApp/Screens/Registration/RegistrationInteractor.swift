//
//  RegistrationInteractor.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 13.08.2023.
//

import Foundation
import FirebaseAuth

final class RegistrationInteractor: Interactable {
    var authenticationProvider: AuthenticationProviderProtocol
    typealias PresenterType = RegistrationPresenter
    var presenter: PresenterType?
    
    init(authenticationProvider: AuthenticationProviderProtocol) {
        self.authenticationProvider = authenticationProvider
    }
    
    func createUser(email: String, password: String) async throws -> AuthDataResult {
        return try await authenticationProvider.signUp(email: email, password: password)
    }
}
