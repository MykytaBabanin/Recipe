//
//  ViewController.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 07.08.2023.
//

import UIKit
import Combine

private typealias ButtonStyle = Login.Button
private typealias TitleStyle = Login.Title
private typealias StackViewStyle = Login.StackView

final class LoginView: UIViewController, Viewable {
    typealias PresenterType = LoginPresenter
    var presenter: PresenterType?
    
    @Published private var authenticationFailure: (username: Bool, password: Bool) = (false, false)
    
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var loginButton: UIButton = {
        ButtonStyle.apply(title: "Submit")
    }()
    
    private lazy var loginStackView: UIStackView = {
        StackViewStyle.apply()
    }()
    
    private lazy var registrationButton: UIButton = {
        ButtonStyle.apply(title: "Registration")
    }()
    
    private lazy var titleLabel: UILabel = {
        TitleStyle.apply(text: "Hello, \nWelcome Back!",
                                 fontSize: 30,
                                 textAlignment: .left)
    }()
    
    private lazy var separatorLabel: UILabel = {
        TitleStyle.apply(text: "Or Sign In With",
                                 fontSize: 11,
                                 textAlignment: .center,
                                 textColor: UIColor(hex: "#D9D9D9"))
    }()
    
    private lazy var dontHaveAccountLabel: UILabel = {
        TitleStyle.applyLink(text: "Don't have an account?",
                             clickableText: "Sign up",
                             target: self,
                             action: #selector(registrationButtonTapped))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupAutoLayout()
        setupBindings()
    }
    
    func checkValidation(_ errors: AuthenticationErrors) {
        successfullyValidateFields()

        for error in errors.errors {
            switch error {
            case .userNameError:
                authenticationFailure.username = true
            case .passwordError:
                authenticationFailure.password = true
            }
        }
    }
    
    func successfullyValidateFields() {
        authenticationFailure.username = false
        authenticationFailure.password = false
    }
    
    private func setupSubviews() {
        view.backgroundColor = .white
        
        view.addSubviewAndDisableAutoresizing(titleLabel)
        view.addSubviewAndDisableAutoresizing(loginStackView)
        
        loginStackView.addArrangedSubview(usernameTextField)
        loginStackView.addArrangedSubview(passwordTextField)
        loginStackView.addArrangedSubview(loginButton)
        loginStackView.addArrangedSubview(separatorLabel)
        loginStackView.addArrangedSubview(dontHaveAccountLabel)
        
        setupHeightComponents()
    }
    
    private func setupHeightComponents() {
        [usernameTextField, passwordTextField, loginButton, registrationButton].forEach { component in
            component.heightAnchor.constraint(equalToConstant: LoginConstants.componentHeight).isActive = true
        }
    }
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            loginStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginStackView.widthAnchor.constraint(equalToConstant: LoginConstants.componentsWidth),
            
            titleLabel.bottomAnchor.constraint(equalTo: loginStackView.topAnchor, constant: -57),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
        ])
    }
    
    private func setupBindings() {
        $authenticationFailure
            .sink { [unowned self] failure in
                applyTextFieldStyle(for: usernameTextField,
                                    isError: failure.username,
                                    placeholder: "Enter email")
                applyTextFieldStyle(for: passwordTextField,
                                    isError: failure.password,
                                    placeholder: "Enter password",
                                    isPassword: true)
            }.store(in: &subscriptions)
        
        loginButton.touchUpInsidePublisher()
            .sink { [weak self] in
                self?.loginButtonTapped()
            }.store(in: &subscriptions)
        
        registrationButton.touchUpInsidePublisher()
            .sink { [weak self] in
                self?.registrationButtonTapped()
            }.store(in: &subscriptions)
    }
    
    private func applyTextFieldStyle(for textField: UITextField,
                                     isError: Bool,
                                     placeholder: String,
                                     isPassword: Bool? = false) {
        Login.TextField.apply(for: textField,
                                     isError: isError,
                                     placeholder: placeholder,
                                     isPassword: isPassword)
    }
    
    @objc private func registrationButtonTapped() {
        presenter?.navigateRegistration()
    }
    
    @objc private func loginButtonTapped() {
        guard let email = usernameTextField.text,
              let password = passwordTextField.text else { return }
        presenter?.authenticate(email: email, password: password)
    }
}

