//
//  TabBarConfiguration.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 01/09/2023.
//

import UIKit

protocol HomeTabBarProtocol: UITabBarController, AnyObject {
    func setupTabBarItems()
}

final class HomeTabBarController: UITabBarController, HomeTabBarProtocol {
    enum Constants {
        static let homeIcon = "home"
        static let homeHighlighted = "selected_home"
        static let savedIcon = "saved"
        static let savedHighlighted = "selected_saved"
        static let calorieCounterIcon = "calories"
        static let calorieCounterIconHighlighted = "calories_selected"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItems()
        tabBar.backgroundColor = GeneralStyle.mainAppColor
    }
    
    func setupTabBarItems() {
        let homeViewController: HomeViewProtocol = HomeConfigurator.build()
        let savedViewController: SavedViewProtocol = SavedConfigurator.build()
        let calorieCounterViewController: CalorieCounterViewProtocol = CalorieCounterConfigurator.build()
        
        homeViewController.tabBarItem.image = UIImage(named: Constants.homeIcon)
        homeViewController.tabBarItem.selectedImage = UIImage(named: Constants.homeHighlighted)
        
        savedViewController.tabBarItem.image = UIImage(named: Constants.savedIcon)
        savedViewController.tabBarItem.selectedImage = UIImage(named: Constants.savedHighlighted)
        
        calorieCounterViewController.tabBarItem.image = UIImage(named: Constants.calorieCounterIcon)
        calorieCounterViewController.tabBarItem.selectedImage = UIImage(named: Constants.calorieCounterIconHighlighted)
        
        viewControllers = [homeViewController, savedViewController, calorieCounterViewController]
    }
}
