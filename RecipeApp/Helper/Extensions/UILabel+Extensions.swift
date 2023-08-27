//
//  UILabel.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 22.08.2023.
//

import UIKit

extension UILabel {
    func createWithLink(normalText: String, clickableText: String, target: Any?, action: Selector) {
        let fullText = "\(normalText)\(clickableText)"
        
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: UIColor(hex: "#FF9C00"), range: NSRange(location: normalText.count, length: clickableText.count))
        
        self.attributedText = attributedString
        self.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGesture)
    }
}
