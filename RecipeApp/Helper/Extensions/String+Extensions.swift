//
//  String+Extensions.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 27.08.2023.
//

import Foundation

extension String {
    func isEmailValid() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    func isUsernameValid() -> Bool {
        let usernameRegex = "^[a-zA-Z ]{2,}$"
        
        let usernameTest = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernameTest.evaluate(with: self)
    }
    
    func isPasswordValid() -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9]).{8,}$"
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: self)
    }
    
    func validateUsername() -> String {
        var message = ""
        
        if !NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z ]{2,}$").evaluate(with: self) {
            message = "Password must be at least 2 characters"
        }
        
        return message
    }
    
    func validatePassword() -> String {
        var message = ""

          if !NSPredicate(format: "SELF MATCHES %@", ".{8,}").evaluate(with: self) {
              message += "Password must be at least 8 characters.\n"
          }

          if !NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: self) {
              message += "Include at least one number.\n"
          }

          if !NSPredicate(format: "SELF MATCHES %@", ".*[!&^%$#@()/]+.*").evaluate(with: self) {
              message += "Include at least one special character.\n"
          }

          if !NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: self) {
              message += "Include at least one uppercase letter.\n"
          }

          return message
    }
    
    func validateEmail() -> String {
        var message = ""

        if !NSPredicate(format: "SELF MATCHES %@", "^[A-Z0-9a-z._%+-]+").evaluate(with: self) {
            message += "Email must include a local part.\n"
        }

        if !NSPredicate(format: "SELF MATCHES %@", ".*@.*").evaluate(with: self) {
            message += "Email must include '@'.\n"
        }

        if !NSPredicate(format: "SELF MATCHES %@", ".*@[A-Za-z0-9.-]+").evaluate(with: self) {
            message += "Email must include a domain.\n"
        }

        if !NSPredicate(format: "SELF MATCHES %@", ".*\\.[A-Za-z]{2,64}").evaluate(with: self) {
            message += "Email must have a valid domain extension.\n"
        }

        return message
    }
}
