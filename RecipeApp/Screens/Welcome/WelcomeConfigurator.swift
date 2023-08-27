//
//  WelcomeConfigurator.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 11.08.2023.
//

import Foundation

final class WelcomeConfigurator {
    static func build() -> WelcomeView {
        let view = WelcomeView()
        let presenter = WelcomePresenter()
        let interactor = WelcomeInteractor()
        let router = WelcomeRouter()
        
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
            
        router.view = view
        
        return view
    }
}
