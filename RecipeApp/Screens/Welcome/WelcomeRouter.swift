//
//  WelcomeRouter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 11.08.2023.
//

import UIKit

protocol WelcomeRouterProtocol: AnyObject {
    var view: WelcomeViewProtocol? { get }
    func navigateLogin()
}

final class WelcomeRouter: WelcomeRouterProtocol {
    var view: WelcomeViewProtocol?

    func navigateLogin() {
        let loginModule = LoginConfigurator.build()
        if let loginModuleVC = loginModule as? UIViewController {
            view?.navigationController?.pushViewController(loginModuleVC, animated: true)
        }
    }
}
