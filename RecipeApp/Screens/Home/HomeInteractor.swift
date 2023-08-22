//
//  HomeInteractor.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 19.08.2023.
//

import Foundation

final class HomeInteractor: Interactable {
    var authenticationProvider: AuthenticationProviderProtocol
    typealias PresenterType = HomePresenter
    var presenter: PresenterType?
    
    init(authenticationProvider: AuthenticationProviderProtocol) {
        self.authenticationProvider = authenticationProvider
    }
}
