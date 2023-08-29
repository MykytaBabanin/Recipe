//
//  HomeView.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 19.08.2023.
//

import UIKit
import SETabView

protocol HomeViewProtocol: AnyObject {
    var presenter: HomePresenterProtocol? { get set }
}

final class HomeView: SETabViewController, HomeViewProtocol {
    var presenter: HomePresenterProtocol?
    
    private let welcomeTitle: UILabel = {
        let label = UILabel()
        label.text = "Hello Jega"
        return label
    }()
    
    private let welcomeSubtitle: UILabel = {
        let label = UILabel()
        label.text = "What are you cooking today?"
        return label
    }()
    
    private let searchRecipe: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let segmentedControl: UISegmentedControl = {
       let segmentedControl = UISegmentedControl()
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = GeneralStyle.mainBackgroundColor
        setupTabBar()
    }
}

private extension HomeView {
    func addSubview() {
        
    }
    
    func setupTabBar() {
        setViewControllers(setupTabBarItems())
        setTabColors(backgroundColor: .white,
                     ballColor: .clear,
                     tintColor: GeneralStyle.mainAppColor,
                     unselectedItemTintColor: .gray,
                     barTintColor: .clear)
    }
    
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
