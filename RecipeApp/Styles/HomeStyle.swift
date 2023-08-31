//
//  HomeStyle.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 31.08.2023.
//

import UIKit

enum Home {
    enum Title {
        static func apply(title: UILabel) {
            title.text = "Hello Jega"
            title.font = .boldSystemFont(ofSize: 20)
        }
        static func apply(subtitle: UILabel) {
            subtitle.text = "What are you cooking today?"
            subtitle.font = .systemFont(ofSize: 12)
            subtitle.textColor = UIColor(hex: "#D9D9D9")
        }
    }
    
    enum Button {
        static func apply(selectEmojiButton: UIButton) {
            selectEmojiButton.backgroundColor = GeneralStyle.mainAppColor
            selectEmojiButton.layer.cornerRadius = 20
        }
    }
    
    enum StackView {
        static func apply(stackView: UIStackView) {
            stackView.axis = .vertical
            stackView.spacing = 3
        }
    }
}
