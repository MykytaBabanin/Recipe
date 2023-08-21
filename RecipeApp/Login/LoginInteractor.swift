//
//  Interactor.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 07.08.2023.
//

import Foundation

class LoginInteractor: Interactable {
    typealias PresenterType = LoginPresenter
    
    var presenter: PresenterType?
    
    func authenticateUser(username: String, password: String) -> Bool {
        username == password ? true : false
    }
}
