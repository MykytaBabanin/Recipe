//
//  Style.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 08.08.2023.
//

import UIKit

enum Welcome {
    enum Image {
        static func apply(for view: UIView, withImage imageName: String) -> UIImageView {
            let backgroundImage = UIImageView(frame: view.bounds)
            backgroundImage.image = UIImage(named: imageName)
            return backgroundImage
        }
    }
    
    enum Button {
        static func apply() -> UIButton {
            return UIButton().buildMainAppButton(title: "Start cooking", backgroundColor: GeneralStyle.mainAppColor, withArrow: true)
        }
    }
}
