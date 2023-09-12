//
//  SavedConfigurator.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 11/09/2023.
//

import Foundation

final class SavedConfigurator {
    static func build() -> SavedViewProtocol {
        let view: SavedViewProtocol = SavedView()
        let interactor: SavedInteractorProtocol = SavedInteractor()
        let router: SavedRouterProtocol = SavedRouter()
        let presenter: SavedPresenterProtocol = SavedPresenter()
        
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        interactor.presenter = presenter
        
        router.view = view
        
        return view
    }
}
