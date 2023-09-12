//
//  FirebaseAuthenticationProvider.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 22.08.2023.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

enum FirebaseConstants {
    static let databaseUrl = "https://recipeapp-3cbe4-default-rtdb.europe-west1.firebasedatabase.app/"
    static let usersDirectory = "users"
    static let ingredientsDirectory = "ingredients"
    static let nameField = "name"
    static let urlField = "url"
}

protocol AuthenticationProviderProtocol: AnyObject {
    func fetchUsername() -> String
    func signIn(email: String, password: String) async throws -> AuthDataResult
    func signUp(username: String, email: String, password: String) async throws -> AuthDataResult
}

final class FirebaseAuthenticationProvider: AuthenticationProviderProtocol {
    func signIn(email: String, password: String) async throws -> AuthDataResult {
        try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let result = result {
                    continuation.resume(returning: result)
                }
            }
        }
    }
    
    func signUp(username: String, email: String, password: String) async throws -> AuthDataResult {
        try await withCheckedThrowingContinuation { continuation in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let result = result {
                    let changeRequest = result.user.createProfileChangeRequest()
                    changeRequest.displayName = username
                    changeRequest.commitChanges { error in
                        if let error = error {
                            continuation.resume(throwing: error)
                        }
                    }
                    continuation.resume(returning: result)
                }
            }
        }
    }
    
    func fetchUsername() -> String {
        guard let username = Auth.auth().currentUser?.displayName else { return "" }
        return username
    }
}
