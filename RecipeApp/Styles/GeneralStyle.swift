//
//  GeneralStyle.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 22.08.2023.
//

import UIKit

struct GeneralStyle {
    static let mainAppColor = UIColor(hex: "#129591")
    static let mainAppTextColor = UIColor(hex: "#165e51")
    static let mainBackgroundColor = UIColor(hex: "#F8F6F4")
    static let mainAppFont = UIFont(name: "AirbnbCereal_W_Md", size: 16)

    static func setupMainAppFont(fontSize: CGFloat, isBold: Bool? = false) -> UIFont {
        guard let font = isBold ?? false ?
        UIFont(name: "AirbnbCereal_W_Lt", size: fontSize) :
        UIFont(name: "AirbnbCereal_W_Md", size: fontSize) else { return UIFont() }
        return font
    }
}
