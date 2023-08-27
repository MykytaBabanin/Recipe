//
//  WelcomeRouter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 11.08.2023.
//

import Foundation

protocol WelcomeRouterProtocol {
    var view: WelcomeView? { get }
    func navigateLogin()
}

final class WelcomeRouter: WelcomeRouterProtocol {
    var view: WelcomeView?

    func navigateLogin() {
        let loginModule = LoginConfigurator.build()
        view?.navigationController?.pushViewController(loginModule, animated: true)
    }
}
