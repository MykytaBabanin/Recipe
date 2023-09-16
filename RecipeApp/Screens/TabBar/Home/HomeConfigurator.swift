//
//  HomeConfigurator.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 08/09/2023.
//

import Foundation

final class HomeConfigurator {
    static func build() -> HomeViewProtocol {
        let fatSecretProvider: FatSecretProviderProtocol = FatSecretAPI()
        let firebaseProvider: AuthenticationProviderProtocol = FirebaseAuthenticationProvider()
        let view: HomeViewProtocol = HomeView(fatSearchProvider: fatSecretProvider, firebaseProvider: firebaseProvider)
        let interactor: HomeInteractorProtocol = HomeInteractor()
        let router: HomeRouterProtocol = HomeRouter()
        let presenter: HomePresenterProtocol = HomePresenter()
        
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        interactor.presenter = presenter
        
        router.view = view
        
        return view
    }
}
