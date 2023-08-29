//
//  HomeRouter.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 19.08.2023.
//

import Foundation

protocol HomeRouterProtocol: AnyObject {
    var view: HomeViewProtocol? { get set }
}

final class HomeRouter: HomeRouterProtocol {
    var view: HomeViewProtocol?
    

}
