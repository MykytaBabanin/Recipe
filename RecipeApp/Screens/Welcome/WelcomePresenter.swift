//
//  WelcomePresenter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 11.08.2023.
//

import Foundation

final class WelcomePresenter: Presentable {
    typealias ViewType = WelcomeView
    typealias InteractorType = WelcomeInteractor
    typealias RouterType = WelcomeRouter
    
    var view: ViewType?
    var interactor: InteractorType?
    var router: RouterType?
    
    
    func navigateLogin() {
        router?.navigateLogin()
    }
}
