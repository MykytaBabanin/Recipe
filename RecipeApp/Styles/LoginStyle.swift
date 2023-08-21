//
//  LoginStyle.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 22.08.2023.
//

import UIKit

enum Login {
    enum TextField {
        static func apply(for textField: UITextField,
                          isError: Bool,
                          placeholder: String,
                          isPassword: Bool?) {
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = isError ? 1 : 0
            textField.isSecureTextEntry = isPassword ?? false
            textField.placeholder = placeholder
            textField.borderStyle = .roundedRect
        }
    }
    enum Button {
        static func apply(title: String) -> UIButton {
            return UIButton().buildMainAppButton(title: title, backgroundColor: GeneralStyle.mainAppColor, withArrow: true)
        }
    }
    enum StackView {
        static func apply() -> UIStackView {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = LoginConstants.componentsSpacing
            return stackView
        }
    }
    enum Title {
        static func apply(text: String,
                          fontSize: CGFloat,
                          textAlignment: NSTextAlignment,
                          textColor: UIColor? = .darkText,
                          withLink: Bool? = false,
                          target: Any? = nil,
                          action: Selector? = nil) -> UILabel {
            let label = UILabel()
            label.font = .systemFont(ofSize: fontSize)
            label.numberOfLines = 0
            label.textAlignment = textAlignment
            label.textColor = textColor
            label.lineBreakMode = .byWordWrapping
            
            if withLink ?? false {
                label.createWithLink(normalText: "Don't have an account?", clickableText: "Sign up", target: target, action: action!)
            } else {
                label.text = text
            }
            
            return label
        }
    }
}
