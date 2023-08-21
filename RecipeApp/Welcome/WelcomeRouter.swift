//
//  WelcomeRouter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 11.08.2023.
//

import Foundation

final class WelcomeRouter: Routable {
    typealias ViewType = WelcomeView
    weak var view: ViewType?
    
    func navigateLogin() {
        let loginModule = LoginConfigurator.build()
        view?.navigationController?.pushViewController(loginModule, animated: true)
    }
}
