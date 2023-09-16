//
//  URLComponents+Extensions.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 06/09/2023.
//

import Foundation

extension URLComponents {
    mutating func createItemsForURLComponentsObject(array: [(key: String, value: String)]) {
        var queryItems = [URLQueryItem]()
        
        for tuple in array {
            queryItems.append(URLQueryItem(name: tuple.key, value: tuple.value))
        }
        
        self.queryItems = queryItems
    }
    
    func getURLParameters() -> String {
        let queryItems = self.queryItems!
        var params = ""
        
        for item in queryItems {
            let index = queryItems.firstIndex(of: item)
            
            if index != queryItems.endIndex - 1 {
                params.append(String(describing: "\(item)&"))
            } else {
                params.append(String(describing: item))
            }
        }
        
        return params
    }
}
