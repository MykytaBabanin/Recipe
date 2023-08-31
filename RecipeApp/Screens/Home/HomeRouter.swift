//
//  HomeRouter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 19.08.2023.
//

import UIKit

protocol HomeRouterProtocol: AnyObject {
    var view: HomeViewProtocol? { get set }
    
    func openFilterSearchView()
}

final class HomeRouter: HomeRouterProtocol {
    var view: HomeViewProtocol?
    
    func openFilterSearchView() {
        let filterView = HomeFilterSearchView()
        if let presentationController = filterView.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        
        view?.navigationController?.present(filterView, animated: true)
    }
}
