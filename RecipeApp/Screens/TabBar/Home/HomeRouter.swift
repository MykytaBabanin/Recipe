//
//  HomeRouter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 19.08.2023.
//

import UIKit
import SafariServices

protocol HomeRouterProtocol: AnyObject {
    var view: HomeViewProtocol? { get set }
    
    func openDetailedPage(with url: String)
}

final class HomeRouter: HomeRouterProtocol {
    var view: HomeViewProtocol?
    
    func openDetailedPage(with url: String) {
        guard let url = URL(string: url) else { return }
        let safariVC = SFSafariViewController(url: url)
        view?.present(safariVC, animated: true, completion: nil)
    }
}
