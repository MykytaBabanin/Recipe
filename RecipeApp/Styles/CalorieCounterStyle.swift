//
//  CalorieCounterStyle.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 26/09/2023.
//

import UIKit

enum CalorieCounter {
    enum DescriptionLabel {
        static func apply(_ label: UILabel) {
            label.font = GeneralStyle.setupMainAppFont(fontSize: 12)
            label.textColor = GeneralStyle.mainAppTextColor
            label.numberOfLines = 0
        }
    }
}
