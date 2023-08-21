//
//  HomePresenter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 19.08.2023.
//

import Foundation

final class HomePresenter: Presentable {
    typealias ViewType = HomeView
    typealias InteractorType = HomeInteractor
    typealias RouterType = HomeRouter
    
    var view: ViewType?
    var interactor: InteractorType?
    var router: RouterType?
}
