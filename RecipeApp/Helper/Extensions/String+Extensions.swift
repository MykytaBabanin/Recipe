//
//  String+Extensions.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 27.08.2023.
//

import Foundation

extension String {
    func validatePassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9]).{8,}$"

        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: self)
    }
    
    func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return passwordTest.evaluate(with: self)
    }
}
