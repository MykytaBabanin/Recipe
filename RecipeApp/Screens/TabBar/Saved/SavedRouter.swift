//
//  SavedRouter.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 11/09/2023.
//

import UIKit

protocol SavedRouterProtocol: AnyObject {
    var view: SavedViewProtocol? { get set }
    
    func openDetailedPage(with url: String)
}

final class SavedRouter: SavedRouterProtocol {
    var view: SavedViewProtocol?
    
    func openDetailedPage(with url: String) {
        if let url = URL(string: url) {
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
