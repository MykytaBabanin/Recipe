//
//  HomeRouter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 19.08.2023.
//

import UIKit

protocol HomeRouterProtocol: AnyObject {
    var view: HomeViewProtocol? { get set }
    
    func openDetailedPage(with url: String)
}

final class HomeRouter: HomeRouterProtocol {
    var view: HomeViewProtocol?
    
    func openDetailedPage(with url: String) {
        if let url = URL(string: url) {
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
