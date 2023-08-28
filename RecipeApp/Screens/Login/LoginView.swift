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

protocol LoginViewProtocol: AnyObject {
    var presenter: LoginPresenterProtocol? { get set }
    var navigationController: UINavigationController? { get }
    
    func checkValidation(_ errors: AuthenticationErrors)
    func successfullyValidateFields()
}

final class LoginView: UIViewController, LoginViewProtocol {
    var presenter: LoginPresenterProtocol?
        
    private let keyboardWillShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
    private let keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
    private lazy var registrationButton: UIButton = { ButtonStyle.apply(title: "Registration") }()
    private lazy var loginStackView: UIStackView = { StackViewStyle.apply() }()
    private var loginButton: UIButton = { ButtonStyle.apply(title: "Submit") }()
    private var subscriptions = Set<AnyCancellable>()
    private let usernameTextField: LabeledTextField = {
        let textField = LabeledTextField()
        let viewState = LabeledTextField.ViewState(placeholder: "Enter email", isPassword: false)
        textField.render(with: viewState)
        return textField
    }()
    private let passwordTextField: LabeledTextField = {
        let textField = LabeledTextField()
        let viewState = LabeledTextField.ViewState(placeholder: "Enter password", isPassword: true)
        textField.render(with: viewState)
        return textField
    }()
    private let contentView = UIView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
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
        disableBackButton()
    }
    
    func checkValidation(_ errors: AuthenticationErrors) {
        successfullyValidateFields()
        
        for error in errors.errors {
            switch error {
            case .userNameError(let error):
                usernameTextField.subtitle = error
                usernameTextField.isError = true
            case .passwordError(let error):
                passwordTextField.subtitle = error
                passwordTextField.isError = true
            }
        }
    }
    
    
    func successfullyValidateFields() {
        usernameTextField.isError = false
        passwordTextField.isError = false
    }
}

private extension LoginView {
    func setupBindings() {
        keyboardWillShowHandling()
        keyboardWillHideHandling()
        touchButtonsHandling()
        setupDelegates()
        setupKeyboardHiddingWhileTapOutside()
    }
    
    func setupSubviews() {
        view.backgroundColor = .white
        view.addSubviewAndDisableAutoresizing(scrollView)
        scrollView.addSubviewAndDisableAutoresizing(contentView)
        
        contentView.addSubviewAndDisableAutoresizing(titleLabel)
        contentView.addSubviewAndDisableAutoresizing(loginStackView)
        
        loginStackView.addArrangedSubview(usernameTextField)
        loginStackView.addArrangedSubview(passwordTextField)
        loginStackView.addArrangedSubview(loginButton)
        loginStackView.addArrangedSubview(separatorLabel)
        loginStackView.addArrangedSubview(dontHaveAccountLabel)
        
        setupHeightComponents()
    }
    
    func setupHeightComponents() {
        [usernameTextField, passwordTextField, loginButton, registrationButton].forEach { component in
            component.heightAnchor.constraint(equalToConstant: LoginConstants.componentHeight).isActive = true
        }
    }
    
    func setupAutoLayout() {
        scrollView.pin(toEdges: view)
        contentView.pin(toEdges: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            loginStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loginStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            loginStackView.widthAnchor.constraint(equalToConstant: LoginConstants.componentsWidth),
            
            titleLabel.bottomAnchor.constraint(equalTo: loginStackView.topAnchor, constant: -57),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
        ])
    }
    
    func keyboardWillShowHandling() {
        keyboardWillShow.sink { [weak self] notification in
            guard let self = self else { return }
            
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardHeight = keyboardSize.height
                var contentInsets = self.scrollView.contentInset
                contentInsets.bottom = keyboardHeight
                self.scrollView.contentInset = contentInsets
                self.scrollView.scrollIndicatorInsets = contentInsets
            }
        }.store(in: &subscriptions)
    }
    
    func keyboardWillHideHandling() {
        keyboardWillHide.sink { [weak self] _ in
            guard let self = self else { return }
            
            var contentInsets = self.scrollView.contentInset
            contentInsets.bottom = 0
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
        .store(in: &subscriptions)
    }
    
    func touchButtonsHandling() {
        loginButton.touchUpInsidePublisher()
            .sink { [weak self] in
                self?.loginButtonTapped()
            }.store(in: &subscriptions)
        
        registrationButton.touchUpInsidePublisher()
            .sink { [weak self] in
                self?.registrationButtonTapped()
            }.store(in: &subscriptions)
    }
    
    func setupDelegates() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func disableBackButton() {
        navigationItem.hidesBackButton = true
    }
    
    func setupKeyboardHiddingWhileTapOutside() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func registrationButtonTapped() {
        presenter?.navigateRegistration()
    }
    
    @objc func loginButtonTapped() {
        guard let email = usernameTextField.text,
              let password = passwordTextField.text else { return }
        let user = AuthorisedUser(userId: "", username: email, password: password)
        presenter?.authenticate(user: user)
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

