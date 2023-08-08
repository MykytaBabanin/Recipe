//
//  RegistrationPresenter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 13.08.2023.
//

import Foundation

final class RegistrationPresenter: Presentable {
    typealias ViewType = RegistrationView
    typealias InteractorType = RegistrationInteractor
    typealias RouterType = RegistrationRouter
    
    var view: ViewType?
    var interactor: InteractorType?
    var router: RouterType?
}
