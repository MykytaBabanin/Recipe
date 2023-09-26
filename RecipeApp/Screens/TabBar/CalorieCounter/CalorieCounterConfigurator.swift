//
//  CalorieCounterConfigurator.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 18/09/2023.
//

import Foundation

final class CalorieCounterConfigurator {
    static func build() -> CalorieCounterViewProtocol {
        let firebaseDataProvider: FirebaseDataProviderProtocol = FirebaseDataProvider()
        let view: CalorieCounterViewProtocol = CalorieCounterView()
        var interactor: CalorieCounterInteractorProtocol = CalorieCounterInteractor()
        var router: CalorieCounterRouterProtocol = CalorieCounterRouter()
        var presenter: CalorieCounterPresenterProtocol = CalorieCounterPresenter()
        
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        interactor.presenter = presenter
        interactor.firebaseDataProvider = firebaseDataProvider
        
        router.view = view
        
        return view
    }
}
