//
//  FirebaseAuthenticationProvider.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 22.08.2023.
//

import Foundation
import FirebaseAuth

protocol AuthenticationProviderProtocol: AnyObject {
    func signIn(email: String, password: String) async throws -> AuthDataResult
    func signUp(email: String, password: String) async throws -> AuthDataResult
}

class FirebaseAuthenticationProvider: AuthenticationProviderProtocol {
    func signIn(email: String, password: String) async throws -> AuthDataResult {
        try await withCheckedThrowingContinuation{ continuation in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: result!)
                }
            }
        }
    }
    
    func signUp(email: String, password: String)async throws -> AuthDataResult {
        try await withCheckedThrowingContinuation{ continuation in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: result!)
                }
            }
        }
    }
}
