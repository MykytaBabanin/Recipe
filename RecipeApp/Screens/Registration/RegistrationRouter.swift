//
//  RegistrationRouter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 13.08.2023.
//

import Foundation

protocol RegistrationRouterProtocol: AnyObject {
    var view: RegistrationViewProtocol? { get set }
    func navigateLogin()
}

final class RegistrationRouter: RegistrationRouterProtocol {
    var view: RegistrationViewProtocol?
    
    func navigateLogin() {
        view?.navigationController?.popViewController(animated: true)
    }
}
