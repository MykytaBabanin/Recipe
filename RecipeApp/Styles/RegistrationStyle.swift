//
//  RegistrationStyle.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 22.08.2023.
//

import UIKit

enum Registration {
    enum StackView {
        static func apply() -> UIStackView {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 20
            return stackView
        }
    }
    enum Label {
        static func apply(text: String, fontSize: CGFloat, fontWeight: UIFont.Weight) -> UILabel{
            let label = UILabel()
            label.text = text
            label.font = GeneralStyle.setupMainAppFont(fontSize: fontSize)
            label.numberOfLines = 0
            return label
        }
    }
    
    enum TextField {
        static func apply(placeholder: String, isSecure: Bool? = false) -> UITextField {
            let textField = UITextField()
            textField.placeholder = placeholder
            textField.borderStyle = .roundedRect
            textField.autocapitalizationType = .none
            textField.isSecureTextEntry = isSecure ?? false
            return textField
        }
    }
}
