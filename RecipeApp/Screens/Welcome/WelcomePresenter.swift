//
//  WelcomePresenter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 11.08.2023.
//

import Foundation

final class WelcomePresenter {
    var view: WelcomeViewProtocol?
    var interactor: WelcomeInteractor?
    var router: WelcomeRouter?
    
    
    func navigateLogin() {
        router?.navigateLogin()
    }
}
