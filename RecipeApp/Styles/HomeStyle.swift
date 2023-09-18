//
//  HomeStyle.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 31.08.2023.
//

import UIKit

enum Home {
    enum Title {
        static func apply(title: UILabel) {
            title.text = "Hello Jega"
            title.font = GeneralStyle.setupMainAppFont(fontSize: 20)
            title.textColor = .white
        }
        static func apply(subtitle: UILabel) {
            subtitle.text = "What are you cooking today?"
            subtitle.font = GeneralStyle.setupMainAppFont(fontSize: 12)
            subtitle.textColor = .white
        }
    }
    
    enum Button {
        static func apply(_ button: UIButton) {
            button.backgroundColor = GeneralStyle.mainAppColor
            button.layer.cornerRadius = 25
        }
    }
    
    enum StackView {
        static func apply(stackView: UIStackView) {
            stackView.axis = .vertical
            stackView.spacing = 3
        }
    }
    
    enum SearchBar {
        static func apply(_ searchBar: UISearchBar) {
            searchBar.placeholder = HomeConstants.searchPlaceholder
            searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
            searchBar.backgroundColor = UIColor.clear
        }
    }
    
    enum ProductLabel {
        static func apply(_ label: UILabel) {
            label.font = GeneralStyle.mainAppFont
            label.textColor = UIColor(hex: "#165e51")
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.textAlignment = .center
        }
    }
    
    enum WelcomeBackLabel {
        static func apply(_ label: UILabel, username: String) {
            label.numberOfLines = 2
            label.font = GeneralStyle.mainAppFont?.withSize(17)
            label.textColor = UIColor(hex: "#165e51")
            label.text = "Welcome back, \(username)!\nTry to find something healthy today!"
        }
    }
    
    enum Layout {
        static func apply(_ layout: UICollectionViewFlowLayout) {
            layout.scrollDirection = .vertical
        }
    }
    
    enum CollectionView {
        static func apply(_ collectionView: UICollectionView, refreshControl: UIRefreshControl) {
            collectionView.backgroundColor = .clear
            collectionView.refreshControl = refreshControl
        }
    }
}
