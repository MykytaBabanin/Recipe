//
//  RegistrationView.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 13.08.2023.
//

import UIKit

final class RegistrationView: UIViewController, Viewable {
    typealias PresenterType = RegistrationPresenter
    var presenter: PresenterType?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}
