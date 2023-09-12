//
//  LoginStyle.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 22.08.2023.
//

import UIKit

enum Login {
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
                          textColor: UIColor? = .darkText) -> UILabel {
            let label = UILabel()
            label.font = GeneralStyle.setupMainAppFont(fontSize: fontSize)
            label.numberOfLines = 0
            label.textAlignment = textAlignment
            label.textColor = textColor
            label.lineBreakMode = .byWordWrapping
            label.text = text
            
            return label
        }
        
        static func applyLink(text: String,
                              clickableText: String,
                              target: Any,
                              action: Selector) -> UILabel {
            let label = UILabel()
            label.createWithLink(normalText: text, clickableText: clickableText, target: target, action: action)
            label.textAlignment = .center
            label.font = GeneralStyle.setupMainAppFont(fontSize: 15)
            return label
        }
    }
}
