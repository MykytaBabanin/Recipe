//
//  GeneralStyle.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 22.08.2023.
//

import UIKit

struct GeneralStyle {
    static let mainAppColor = UIColor(hex: "#129575")
    static let whiteColor = UIColor(hex: "#FFFFFF")
    static let mainBackgroundColor = UIColor(hex: "#9ED2BE")
    static let mainAppFont = UIFont(name: "AirbnbCereal_W_Bk", size: 16)

    static func setupMainAppFont(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "AirbnbCereal_W_Lt", size: fontSize) ?? UIFont()
    }
}
