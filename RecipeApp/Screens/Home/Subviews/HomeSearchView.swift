//
//  HomeSearchView.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 31.08.2023.
//

import UIKit
import Combine

protocol HomeSearchDelegate: AnyObject {
    func openFilterSearch()
}

class HomeSearchView: UIView {
    weak var delegate: HomeSearchDelegate?
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search recipe"
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.backgroundColor = UIColor.clear
        return searchBar
    }()
    
    private lazy var filterButton: UIButton = {
        let filterButton = UIButton()
        filterButton.backgroundColor = GeneralStyle.mainAppColor
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        filterButton.layer.cornerRadius = 20
        return filterButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
        setupAutoLayout()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeSearchView {
    func setupBindings() {
        filterButton.touchUpInsidePublisher()
            .sink { [weak self] in
                self?.delegate?.openFilterSearch()
            }.store(in: &subscriptions)
    }
    
    func setupSubview() {
        addSubviewAndDisableAutoresizing(searchBar)
        addSubviewAndDisableAutoresizing(filterButton)
    }
    
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -30),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            filterButton.widthAnchor.constraint(equalToConstant: 60),
            filterButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

