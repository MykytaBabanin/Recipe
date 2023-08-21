//
//  ModuleBuilder.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 11.08.2023.
//

import Foundation

final class ModuleBuilder<View: Viewable, Presenter: Presentable, Interactor: Interactable, Router: Routable> where View.PresenterType == Presenter,
                                                                                                              Presenter.InteractorType == Interactor,
                                                                                                              Presenter.RouterType == Router,
                                                                                                              Presenter.ViewType == View,
                                                                                                              Interactor.PresenterType == Presenter,
                                                                                                              Router.ViewType == View {
    static func build(view: View, presenter: Presenter, interactor: Interactor, router: Router) -> View{
        view.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        interactor.presenter = presenter
        
        router.view = view
        
        return view
    }
}
