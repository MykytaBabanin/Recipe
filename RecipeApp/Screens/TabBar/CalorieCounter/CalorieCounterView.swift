//
//  CalorieCounterView.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 18/09/2023.
//

import UIKit

protocol CalorieCounterViewProtocol: UIViewController, AnyObject {
    var presenter: CalorieCounterPresenterProtocol? { get set }
}

final class CalorieCounterView: UIViewController, CalorieCounterViewProtocol {
    var presenter: CalorieCounterPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
