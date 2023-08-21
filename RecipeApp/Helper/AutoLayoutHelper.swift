//
//  AutoLayoutHelper.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 22.08.2023.
//

import UIKit

extension UIViewController {
    func applyHeight(components: [UIView], constant: CGFloat) {
        components.forEach { component in
            component.heightAnchor.constraint(equalToConstant: constant).isActive = true
        }
    }
}
