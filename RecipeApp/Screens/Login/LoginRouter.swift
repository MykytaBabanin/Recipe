//
//  Router.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 07.08.2023.
//

import Foundation
import UIKit

final class LoginRouter: Routable {
    typealias ViewType = LoginView
    
    weak var view: ViewType?
    
    func disableBackButton() {
        view?.navigationItem.hidesBackButton = true
    }
    
    func navigateHome() {
        let homeModule = HomeConfigurator.build()
        view?.navigationController?.pushViewController(homeModule, animated: true)
    }
    
    func navigateRegistration() {
        let registrationModule = RegistrationConfigurator.build()
        registrationModule.presenter?.disableBackButton()
        view?.navigationController?.pushViewController(registrationModule, animated: true)
    }
}
