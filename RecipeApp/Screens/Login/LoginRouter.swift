//
//  Router.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 07.08.2023.
//

import Foundation
import UIKit

protocol LoginRouterProtocol: AnyObject {
    var view: LoginViewProtocol? { get set }
    
    func navigateHome()
    func navigateRegistration()
}

final class LoginRouter: LoginRouterProtocol {
    var view: LoginViewProtocol?
    
    func navigateHome() {
        let tabBarModule = TabBarConfigurator.build()
        view?.navigationController?.pushViewController(tabBarModule, animated: true)
    }
    
    func navigateRegistration() {
        let registrationModule = RegistrationConfigurator.build()
        view?.navigationController?.pushViewController(registrationModule as! UIViewController, animated: true)
    }
}
