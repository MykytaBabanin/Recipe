//
//  String+Extensions.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 27.08.2023.
//

import Foundation
import UIKit
import CryptoSwift

extension CharacterSet {
    var percentEncoded: CharacterSet {
        get { return CharacterSet.init(charactersIn: String().getPercentEncodingCharacterSet()) }
    }
}

extension String {
    func getPercentEncodingCharacterSet() -> String {
        let digits = "0123456789"
        let lowercase = "abcdefghijklmnopqrstuvwxyz"
        let uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let reserved = "-._~"
        
        return digits + lowercase + uppercase + reserved
    }
    
    func getSignature(key: String, params: String) -> String {
        var array = [UInt8]()
        array += params.utf8
        
        let sign = try! HMAC(key: key, variant: .sha1).authenticate(array).toBase64()
        
        return sign
    }
    
    func contains(find: String) -> Bool{ return self.range(of: find) != nil }
    
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
    
    func textToImage() -> UIImage? {
        let nsString = (self as NSString)
        let font = UIFont.systemFont(ofSize: 1024)
        let stringAttributes = [NSAttributedString.Key.font: font]
        let imageSize = nsString.size(withAttributes: stringAttributes)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        UIColor.clear.set()
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize))
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
}
