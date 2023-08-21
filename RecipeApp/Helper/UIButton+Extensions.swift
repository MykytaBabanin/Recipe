//
//  UIButton+Extensions.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 22.08.2023.
//

import UIKit

extension UIButton {
    func buildMainAppButton(title: String,
                            backgroundColor: UIColor,
                            withArrow: Bool) -> UIButton {
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.title = title
        if withArrow {
            buttonConfiguration.image = UIImage(named: "arrowRight")
        }
        buttonConfiguration.cornerStyle = .dynamic
        buttonConfiguration.baseBackgroundColor = backgroundColor
        
        let button = UIButton(configuration: buttonConfiguration, primaryAction: nil)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }
}
