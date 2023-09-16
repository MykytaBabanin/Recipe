//
//  Array+Extension.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 06/09/2023.
//

import Foundation

extension Array {
    var parameters: [(key: String, value: String)] {
        get{
            var array = [(key: String, value: String)]()
            
            for (key,value) in OauthConstants.oAuth {
                array.append((key: key, value: value))
            }
            
            for (key,value) in OauthConstants.fatSecret {
                array.append((key: key, value: value))
            }
            
            return array.sorted(by: { $0 < $1 })
        }
    }
}
