//
//  Router.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 07.08.2023.
//

import Foundation
import UIKit

class LoginRouter: Routable {
    typealias ViewType = LoginView
    weak var view: ViewType?
    
    func navigateHome() {}
    func navigateRegistration() {
        let registrationModule = RegistrationConfigurator.build()
        view?.navigationController?.pushViewController(registrationModule, animated: true)
    }
}
