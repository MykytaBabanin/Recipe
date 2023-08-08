//
//  WelcomeView.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 11.08.2023.
//

import UIKit

private struct Constants {
    fileprivate struct LayoutConstants {
        static let logoSize: CGFloat = 80
        static let logoTopOffset: CGFloat = 100
        static let startButtonBottomOffset: CGFloat = -100
    }
    fileprivate struct ImagePathConstants {
        static let backgroundImage = "welcomeBackground"
        static let logoImage = "logoImage"
        static let logoSubtitleImage = "logoSubtitle"
        static let mainSubtitleImage = "mainSubtitle"
        static let mainTitleImage = "mainTitle"
    }
}

typealias ImageStyle = Styles.Welcome.Image
typealias ButtonStyle = Styles.Welcome.Button

final class WelcomeView: UIViewController, Viewable {
    typealias PresenterType = WelcomePresenter
    
    var presenter: PresenterType?
    
    //MARK: Як не робити постійне присвоєння до view
    private lazy var backgroundImageView: UIImageView = {
        ImageStyle.apply(for: view, withImage: Constants.ImagePathConstants.backgroundImage)
    }()
    
    private lazy var logoImageView: UIImageView = {
        ImageStyle.apply(for: view, withImage: Constants.ImagePathConstants.logoImage)
    }()
    
    private lazy var logoSubtitleImageView: UIImageView = {
        ImageStyle.apply(for: view, withImage: Constants.ImagePathConstants.logoSubtitleImage)
    }()
    
    private lazy var startButton: UIButton = {
        ButtonStyle.apply(for: view)
    }()
    
    private lazy var mainSubtitle: UIImageView = {
        ImageStyle.apply(for: view, withImage: Constants.ImagePathConstants.mainSubtitleImage)
    }()
    
    private lazy var mainTitle: UIImageView = {
        ImageStyle.apply(for: view, withImage: Constants.ImagePathConstants.mainTitleImage)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setupAutoLayout()
        setupActions()
    }
    
    private func addSubview() {
        view.insertSubview(backgroundImageView, at: 0)
        
        [logoImageView, logoSubtitleImageView, startButton, mainSubtitle, mainTitle].forEach { view.addSubviewAndDisableAutoresizing($0)
        }
    }
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: Constants.LayoutConstants.logoSize),
            logoImageView.heightAnchor.constraint(equalToConstant: Constants.LayoutConstants.logoSize),
            
            logoSubtitleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoSubtitleImageView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 14),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.LayoutConstants.startButtonBottomOffset),
            //MARK: Чи гарний підхід юзати multiplier для адаптивної верстки на інакших екранах???
            startButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            startButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),
            
            mainSubtitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainSubtitle.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -64),
            
            mainTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainTitle.bottomAnchor.constraint(equalTo: mainSubtitle.topAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc private func startButtonTapped() {
        presenter?.navigateLogin()
    }
}
