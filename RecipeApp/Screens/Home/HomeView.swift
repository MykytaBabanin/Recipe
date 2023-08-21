//
//  HomeView.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 19.08.2023.
//

import UIKit

final class HomeView: UIViewController, Viewable {
    typealias PresenterType = HomePresenter
    var presenter: PresenterType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}
