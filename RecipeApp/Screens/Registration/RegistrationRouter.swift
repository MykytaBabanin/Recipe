//
//  RegistrationRouter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 13.08.2023.
//

import Foundation

protocol RegistrationRouterProtocol: AnyObject {
    var view: RegistrationView? { get }
}

final class RegistrationRouter: RegistrationRouterProtocol {
    var view: RegistrationView?
    
    func navigateLogin() {
        view?.navigationController?.popViewController(animated: true)
    }
}
