//
//  SavedStyle.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 18/09/2023.
//

import UIKit

enum Saved {
    enum Label {
        static func apply(_ label: UILabel) {
            label.text = "Here you can find your saved ingredients"
            label.textColor = GeneralStyle.mainAppTextColor
            label.font = GeneralStyle.mainAppFont?.withSize(18)
        }
    }
}
