//
//  FatSecretProvider.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 05/09/2023.
//

import Foundation
import CryptoSwift

// HTTP Method: POST
// URL Request: https://platform.fatsecret.com/rest/server.api

// Params
// format:json
// oauth_consumer_key:**********
// oauth_signature_method:HMAC-SHA1
// oauth_timestamp:**********
// oauth_nonce:**********
// oauth_version:1.0
// oauth_signature:**********

protocol FatSecretProviderProtocol: AnyObject {
    var key: String { get set }
    var secret: String { get set }
    
    func searchFoodBy(name: String, completion: @escaping (Result<FoodSearch, FatSecretError>) -> ())
    func getFoodBy(id: String,  completion: @escaping (Result<FoodResponse, FatSecretError>) -> ())
}

struct OauthConstants {
    static var oAuth = ["oauth_consumer_key":"",
                        "oauth_signature_method":"HMAC-SHA1",
                        "oauth_timestamp":"",
                        "oauth_nonce":"",
                        "oauth_version":"1.0"] as Dictionary
    static var fatSecret = [:] as Dictionary<String, String>
    static var key = ""
    static let url = "https://platform.fatsecret.com/rest/server.api"
    static let httpType = "POST"
}

struct FatSecret {
    static let apiKey = "aa7f6b0434b744edbc04addc97158178"
    static let apiSecret = "d0f70b33f2b2420a9eb3bf1a87b08ada"
}

enum FatSecretError: Error {
    case failedToRetrieveData
    case invalidURL
    case failedToDecode
}

final class FatSecretAPI: FatSecretProviderProtocol {
    private var _key: String?
    private var _secret: String?
    
    var key: String {
        set {
            _key = newValue
            OauthConstants.oAuth.updateValue(_key!, forKey: "oauth_consumer_key")
        }
        get { return _key ?? "" }
    }
    
    var secret: String {
        set {
            _secret = newValue
            OauthConstants.key = "\(_secret!)&"
        }
        get { return _secret ?? "" }
    }
    
    func searchFoodBy(name: String,
                      completion: @escaping (Result<FoodSearch, FatSecretError>) -> ()) {
        OauthConstants.fatSecret = ["format":"json", "method":"foods.search", "search_expression":name] as Dictionary
        
        let components = generateSignature()
        Task {
            do {
                await fatSecretRequestWith(components: components, decodeType: FoodSearch.self) { result in
                    switch result {
                    case .success(let foodSearch):
                        completion(.success(foodSearch))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func getFoodBy(id: String, completion: @escaping (Result<FoodResponse, FatSecretError>) -> ()) {
        OauthConstants.fatSecret = ["format":"json", "method":"food.get", "food_id":id] as Dictionary
        
        let components = generateSignature()
        Task {
            do {
                await fatSecretRequestWith(components: components, decodeType: FoodResponse.self, completion: { result in
                    switch result {
                    case .success(let specificIngredient):
                        completion(.success(specificIngredient))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
            }
        }
    }
}

private extension FatSecretAPI {
    private var timestamp: String {
        get { return String(Int(Date().timeIntervalSince1970)) }
    }
    
    private var nonce: String {
        get {
            var string: String = ""
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let char = Array(letters)
            
            for _ in 1...7 { string.append(char[Int(arc4random()) % char.count]) }
            
            return string
        }
    }
    
    private func generateSignature() -> URLComponents {
        OauthConstants.oAuth.updateValue(self.timestamp, forKey: "oauth_timestamp")
        OauthConstants.oAuth.updateValue(self.nonce, forKey: "oauth_nonce")
        
        var components = URLComponents(string: OauthConstants.url)!
        components.createItemsForURLComponentsObject(array: Array<String>().parameters)
        
        let parameters = components.getURLParameters()
        let encodedURL = OauthConstants.url.addingPercentEncoding(withAllowedCharacters: CharacterSet().percentEncoded)!
        let encodedParameters = parameters.addingPercentEncoding(withAllowedCharacters: CharacterSet().percentEncoded)!
        let signatureBaseString = "\(OauthConstants.httpType)&\(encodedURL)&\(encodedParameters)".replacingOccurrences(of: "%20", with: "%2520")
        let signature = String().getSignature(key: OauthConstants.key, params: signatureBaseString)
        
        components.queryItems?.append(URLQueryItem(name: "oauth_signature", value: signature))
        return components
    }
    
    private func fatSecretRequestWith<T: Decodable>(components: URLComponents,
                                                    decodeType: T.Type,
                                                    completion: @escaping (Result<T, FatSecretError>) -> ()) async {
        guard let url = URL(string: String(describing: components).replacingOccurrences(of: "+", with: "%2B")) else {
            completion(.failure(.invalidURL))
            return 
        }
        var request = URLRequest(url: url)
        request.httpMethod = OauthConstants.httpType
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            do {
                let searchObject = try decoder.decode(T.self, from: data)
                completion(.success(searchObject))
            } catch {
                completion(.failure(.failedToDecode))
            }
        } catch {
            completion(.failure(.failedToRetrieveData))
        }
    }

    
    private func retrieve<T: Decodable>(data: Data, type: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(type, from: data)
            return model
        } catch {
            return nil
        }
    }
}
