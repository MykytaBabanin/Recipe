//
//  TabBarConfiguration.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 01/09/2023.
//

import UIKit

class TabBarConfiguration {
    static let shared = TabBarConfiguration()
    
    private init() {}
    
    func setupTabBarItems() -> [UIViewController] {
        let viewController1 = UIViewController()
        let viewController2 = UIViewController()
        let viewController3 = UIViewController()
        let viewController4 = UIViewController()
        let viewController5 = UIViewController()
        
        viewController1.tabBarItem.image = UIImage(named: "home")
        viewController1.tabBarItem.selectedImage = UIImage(named: "selected_home")
        
        viewController2.tabBarItem.image = UIImage(named: "saved")
        viewController2.tabBarItem.selectedImage = UIImage(named: "selected_saved")
        
        viewController4.tabBarItem.image = UIImage(named: "notification")
        viewController4.tabBarItem.selectedImage = UIImage(named: "selected_notification")
        
        viewController5.tabBarItem.image = UIImage(named: "profile")
        viewController5.tabBarItem.selectedImage = UIImage(named: "selected_profile")
        
        viewController3.tabBarItem.image = UIImage(named: "create_receipt")
        
        return [viewController1, viewController2, viewController3, viewController4, viewController5]
    }
}
