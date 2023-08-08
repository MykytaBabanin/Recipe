//
//  ViewController.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 07.08.2023.
//

import UIKit

final class LoginView: UIViewController, Viewable {
    typealias PresenterType = LoginPresenter

    var presenter: PresenterType?
    
    private lazy var usernameTextField: UITextField = {
        Styles.Login.TextField.apply(for: view)
    }()
    
    private lazy var passwordTextField: UITextField = {
        Styles.Login.TextField.apply(for: view)
    }()
    
    private lazy var loginButton: UIButton = {
        Styles.Login.Button.apply(for: view)
    }()
    
    private lazy var loginStackView: UIStackView = {
        Styles.Login.StackView.apply(for: view)
    }()
    
    private lazy var registrationButton: UIButton = {
        Styles.Login.Button.apply(for: view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupAutoLayout()
        setupStyle()
        setupActions()
    }
    
    private func setupSubviews() {
        view.addSubviewAndDisableAutoresizing(loginStackView)
        
        loginStackView.addArrangedSubview(usernameTextField)
        loginStackView.addArrangedSubview(passwordTextField)
        loginStackView.addArrangedSubview(loginButton)
        loginStackView.addArrangedSubview(registrationButton)
    }
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            loginStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginStackView.widthAnchor.constraint(equalToConstant: LoginConstants.componentsWidth),
        ])
    }
    
    private func setupStyle() {
        view.backgroundColor = .white
        loginStackView.spacing = LoginConstants.componentsSpacing
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registrationButton.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
    }
    
    @objc private func registrationButtonTapped() {
        presenter?.navigateRegistration()
    }
    
    @objc private func loginButtonTapped() {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text else { return }
        presenter?.authenticate(username: username, password: password)
    }
    
    func showError(_ error: Error) {
        print("\(error) Error blablabla")
    }
}

