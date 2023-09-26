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
        static let homeIcon = "magnifyingglass"
        static let savedIcon = "bookmark"
        static let savedHighlighted = "bookmark.fill"
        static let calorieCounterIcon = "scalemass"
        static let calorieCounterIconHighlighted = "scalemass.fill"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItems()
        tabBar.backgroundColor = GeneralStyle.mainAppColor
    }
    
    func setupTabBarItems() {
        viewControllers = [
            createViewController(HomeConfigurator.build(),
                                 image: Constants.homeIcon,
                                 selectedImage: Constants.homeIcon),
            createViewController(SavedConfigurator.build(),
                                 image: Constants.savedIcon,
                                 selectedImage: Constants.savedHighlighted),
            createViewController(CalorieCounterConfigurator.build(),
                                 image: Constants.calorieCounterIcon,
                                 selectedImage: Constants.calorieCounterIconHighlighted)
        ]
    }

    func createViewController(_ viewController: UIViewController, image: String, selectedImage: String) -> UIViewController {
        viewController.tabBarItem.image = UIImage(systemName: image)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        viewController.tabBarItem.selectedImage = UIImage(systemName: selectedImage)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        return viewController
    }
}
