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
    func presentFailureAuthenticationAlert(with error: Error)
    func successfullyValidateFields()
}

final class LoginView: UIViewController, LoginViewProtocol {
    enum Constants {
        static let registrationButtonTitle = "Registration"
        static let loginButtonTitle = "Submit"
        static let usernameTextFieldPlaceholder = "Enter email"
        static let passwordTextFieldPlaceholder = "Enter password"
        static let titleLabelText = "Hello, \nWelcome Back!"
        static let separatorLabelText = "Or Sign In With"
        static let dontHaveAccountLabelText = "Don't have an account?"
        static let dontHaveAccountLabelClickableText = "Sign up"
        static let authenticationErrorTitle = "Authentication Error"
        static let alertAction = "Ok"
        static let titleLabelInsets = UIEdgeInsets(top: 0, left: 30, bottom: 57, right: 0)
        static let titleLabelFontSize: CGFloat = 30
        static let separatorLabelFontSize: CGFloat = 11
    }
    
    var presenter: LoginPresenterProtocol?
        
    private let keyboardWillShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
    private let keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
    private lazy var registrationButton: UIButton = { ButtonStyle.apply(title: Constants.registrationButtonTitle) }()
    private lazy var loginStackView: UIStackView = { StackViewStyle.apply() }()
    private var loginButton: UIButton = { ButtonStyle.apply(title: Constants.loginButtonTitle) }()
    private var subscriptions = Set<AnyCancellable>()
    private let usernameTextField: LabeledTextField = {
        let textField = LabeledTextField()
        let viewState = LabeledTextField.ViewState(placeholder: Constants.usernameTextFieldPlaceholder, isPassword: false)
        textField.render(with: viewState)
        return textField
    }()
    private let passwordTextField: LabeledTextField = {
        let textField = LabeledTextField()
        let viewState = LabeledTextField.ViewState(placeholder: Constants.passwordTextFieldPlaceholder, isPassword: true)
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
        TitleStyle.apply(text: Constants.titleLabelText,
                         fontSize: Constants.titleLabelFontSize,
                         textAlignment: .left)
    }()
    
    private lazy var dontHaveAccountLabel: UILabel = {
        TitleStyle.applyLink(text: Constants.dontHaveAccountLabelText,
                             clickableText: Constants.dontHaveAccountLabelClickableText,
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
        
        errors.errors.forEach { [weak self] error in
            guard let self = self else { return }
            
            switch error {
            case .username(let error):
                usernameTextField.subtitle = error
                usernameTextField.isError = true
            case .password(let error):
                passwordTextField.subtitle = error
                passwordTextField.isError = true
            }
        }
    }
    
    
    func successfullyValidateFields() {
        usernameTextField.isError = false
        passwordTextField.isError = false
    }
    
    func presentFailureAuthenticationAlert(with error: Error) {
        let alert = UIAlertController(title: Constants.authenticationErrorTitle, message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.alertAction, style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
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
        view.backgroundColor = GeneralStyle.mainBackgroundColor
        view.addSubviewAndDisableAutoresizing(scrollView)
        scrollView.addSubviewAndDisableAutoresizing(contentView)
        
        contentView.addSubviewAndDisableAutoresizing(titleLabel)
        contentView.addSubviewAndDisableAutoresizing(loginStackView)
        
        loginStackView.addArrangedSubview(usernameTextField)
        loginStackView.addArrangedSubview(passwordTextField)
        loginStackView.addArrangedSubview(loginButton)
        loginStackView.addArrangedSubview(dontHaveAccountLabel)
        
        setupHeightComponents()
    }
    
    func setupHeightComponents() {
        [usernameTextField, passwordTextField, loginButton, registrationButton].forEach { component in
            component.heightAnchor.constraint(equalToConstant: LoginConstants.componentHeight).isActive = true
        }
    }
    
    func setupAutoLayout() {
        contentView.pin(toEdges: scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            loginStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loginStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            loginStackView.widthAnchor.constraint(equalToConstant: LoginConstants.componentsWidth),
            
            titleLabel.bottomAnchor.constraint(equalTo: loginStackView.topAnchor, constant: -Constants.titleLabelInsets.bottom),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.titleLabelInsets.left),
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

