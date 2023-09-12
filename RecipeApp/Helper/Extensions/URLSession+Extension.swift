//
//  URLSession+Extension.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 06/09/2023.
//

import Foundation

extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: NSError(domain: "Unknown error", code: -1, userInfo: nil))
                }
            }
            task.resume()
        }
    }
}
