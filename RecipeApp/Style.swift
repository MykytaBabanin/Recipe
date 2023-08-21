//
//  Style.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 08.08.2023.
//

import UIKit

enum Styles {
    enum Welcome {
        enum Image {
            static func apply(for view: UIView, withImage imageName: String) -> UIImageView {
                let backgroundImage = UIImageView(frame: view.bounds)
                backgroundImage.image = UIImage(named: imageName)
                return backgroundImage
            }
        }
        
        enum Button {
            static func apply(for view: UIView) -> UIButton {
                let button = UIButton()
                button.layer.cornerRadius = 10
                button.backgroundColor = UIColor(hex: "#129575")
                button.titleLabel?.textColor = UIColor(hex: "#FFFFFF")
                button.setTitle("Start cooking", for: .normal)
                button.setImage(UIImage(named: "arrowRight"), for: .normal)
                button.semanticContentAttribute = .forceRightToLeft
                return button
            }
        }
    }
    
    enum Login {
        enum TextField {
            static func apply(for view: UIView) -> UITextField {
                let textField = UITextField()
                textField.borderStyle = .roundedRect
                return textField
            }
        }
        enum Button {
            static func apply(for view: UIView) -> UIButton {
                let button = UIButton()
                button.backgroundColor = .blue
                return button
            }
        }
        enum StackView {
            static func apply(for view: UIView) -> UIStackView {
                let stackView = UIStackView()
                stackView.axis = .vertical
                return stackView
            }
        }
    }
}
