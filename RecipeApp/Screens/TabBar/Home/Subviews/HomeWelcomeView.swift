//
//  HomeWelcomeView.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 11/09/2023.
//

import UIKit

final class HomeWelcomeView: UIView {
    enum Constants {
        static let welcomeViewAnimationSize: CGFloat = 150
        static let welcomeAnimationTrailingSpace: CGFloat = 40
        static let welcomeBackLabelLeadingSpace: CGFloat = 15
    }
    private let firebaseProvider: AuthenticationProviderProtocol
    
    private lazy var welcomeBackLabel: UILabel = {
        let label = UILabel()
        Home.WelcomeBackLabel.apply(label, username: firebaseProvider.fetchUsername())
        return label
    }()
    
    init(firebaseProvider: AuthenticationProviderProtocol) {
        self.firebaseProvider = firebaseProvider
        super.init(frame: .zero)
        setupSubview()
        setupAutoLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeWelcomeView {
    func setupSubview() {
        addSubviewAndDisableAutoresizing(welcomeBackLabel)
    }
    
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            welcomeBackLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.welcomeBackLabelLeadingSpace),
            welcomeBackLabel.topAnchor.constraint(equalTo: topAnchor),
            welcomeBackLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
