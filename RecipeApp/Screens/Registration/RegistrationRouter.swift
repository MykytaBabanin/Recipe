//
//  RegistrationRouter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 13.08.2023.
//

import Foundation

final class RegistrationRouter: Routable {    
    typealias ViewType = RegistrationView
    
    var view: ViewType?
    
    func disableBackButton() {
        view?.navigationItem.hidesBackButton = true
    }
    
    func navigateLogin() {
        view?.navigationController?.popViewController(animated: true)
    }
}
