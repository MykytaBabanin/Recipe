//
//  HomeInteractor.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 19.08.2023.
//

import Foundation

protocol HomeInteractorProtocol: AnyObject {
    var presenter: HomePresenterProtocol? { get set }
}

final class HomeInteractor: HomeInteractorProtocol {    
    var presenter: HomePresenterProtocol?
}
