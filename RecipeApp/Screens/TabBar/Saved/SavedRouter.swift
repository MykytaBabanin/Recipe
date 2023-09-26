//
//  SavedRouter.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 11/09/2023.
//

import UIKit
import SafariServices

protocol SavedRouterProtocol: AnyObject {
    var view: SavedViewProtocol? { get set }
    
    func openDetailedPage(with url: String)
}

final class SavedRouter: SavedRouterProtocol {
    var view: SavedViewProtocol?
    
    func openDetailedPage(with url: String) {
        guard let url = URL(string: url) else { return }
        let safariVC = SFSafariViewController(url: url)
        view?.present(safariVC, animated: true, completion: nil)
    }
}
