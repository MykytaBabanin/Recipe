//
//  BaseProtocols.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 11.08.2023.
//

import Foundation

protocol Viewable: AnyObject {
    associatedtype PresenterType: Presentable
    var presenter: PresenterType? { get set }
}

protocol Presentable: AnyObject {
    associatedtype ViewType: Viewable
    associatedtype InteractorType
    associatedtype RouterType
    
    var view: ViewType? { get set }
    var interactor: InteractorType? { get set }
    var router: RouterType? { get set }
}

protocol Interactable: AnyObject {
    associatedtype PresenterType: Presentable
    var presenter: PresenterType? { get set }
}

protocol Routable: AnyObject {
    associatedtype ViewType: Viewable
//    associatedtype ConfiguratorType: Configurable
    
//    var configurator: ConfiguratorType? { get set }
    var view: ViewType? { get set }
}

//protocol Configurable: AnyObject {
//    associatedtype ViewType: Viewable
//    static func build() -> ViewType
//}
