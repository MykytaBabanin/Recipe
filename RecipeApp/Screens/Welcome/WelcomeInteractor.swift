//
//  WelcomeInteractor.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 11.08.2023.
//

import Foundation

final class WelcomeInteractor: Interactable {
    var authenticationProvider: AuthenticationProviderProtocol
    typealias PresenterType = WelcomePresenter
    var presenter: PresenterType?
    
    init(authenticationProvider: AuthenticationProviderProtocol) {
        self.authenticationProvider = authenticationProvider
    }
}
