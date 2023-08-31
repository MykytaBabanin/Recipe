//
//  HomeView.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 19.08.2023.
//

import UIKit
import PhotosUI

protocol HomeViewProtocol: AnyObject {
    var presenter: HomePresenterProtocol? { get set }
    var navigationController: UINavigationController? { get }
}

final class HomeView: UITabBarController, HomeViewProtocol, HomeHeaderViewDelegate, HomeSearchDelegate {
    var presenter: HomePresenterProtocol?
    
    private lazy var homeHeaderView: HomeHeaderView = {
        let view = HomeHeaderView(frame: .zero)
        return view
    }()
    
    private lazy var homeSearchView: HomeSearchView = {
        let view = HomeSearchView()
        return view
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
        view.backgroundColor = .white
        viewControllers = setupTabBarItems()
        setupSubviews()
        setupAutoLayout()
        
        homeHeaderView.delegate = self
        homeSearchView.delegate = self
    }
    
    func presentPicker(_ picker: PHPickerViewController) {
        present(picker, animated: true, completion: nil)
    }
    
    func openFilterSearch() {
        presenter?.openFilterSearchView()
    }
}

private extension HomeView {
    func setupSubviews() {
        view.addSubviewAndDisableAutoresizing(homeHeaderView)
        view.addSubviewAndDisableAutoresizing(homeSearchView)
        view.addSubviewAndDisableAutoresizing(filterButton)
        view.addSubviewAndDisableAutoresizing(segmentedControl)
    }
    
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            homeHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeHeaderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            homeHeaderView.heightAnchor.constraint(equalToConstant: 60),
            homeHeaderView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            homeSearchView.topAnchor.constraint(equalTo: homeHeaderView.bottomAnchor, constant: 10),
            homeSearchView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
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
