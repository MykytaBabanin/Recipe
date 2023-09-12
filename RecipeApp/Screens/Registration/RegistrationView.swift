//
//  RegistrationView.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 13.08.2023.
//

import UIKit
import Combine
import FirebaseAuth

protocol RegistrationViewProtocol: AnyObject {
    var presenter: RegistrationPresenterProtocol? { get set }
    var navigationController: UINavigationController? { get }

    func checkValidation(_ errors: RegistrationErrors)
    func successfullyValidateFields(error: Error?)
}

final class RegistrationView: UIViewController, RegistrationViewProtocol {
    enum Constants {
        static let accountTitle = "Create Account"
        static let accountSubtitle = "Let’s help you set up your account,\nit won’t take long."
        static let nameTextFieldPlaceholder = "Enter name"
        static let emailFieldPlaceholder = "Enter email"
        static let passwordFieldPlaceholder = "Enter password"
        static let confirmationPasswordFieldPlaceholder = "Enter confirmation password"
        static let registrationButtonTitle = "Sign up"
        static let alreadyMemberLabelTitle = "Already a member?"
        static let alreadyMemberClickableText = "Sign In"
        static let separatorLabelTitle = "Or Sign In With"
        static let registrationErrorTitle = "Registration Error"
        static let alertAction = "Ok"
        
        static let accountTitleFontSize: CGFloat = 20
        static let accountSubtitleFontSize: CGFloat = 15
        static let separatorLabelFontSize: CGFloat = 11
        static let componentsHeight: CGFloat = 55
    }
    
    var presenter: RegistrationPresenterProtocol?
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var registrationStackView: UIStackView = {
        Registration.StackView.apply()
    }()
    
    private lazy var accountTitle: UILabel = {
        Registration.Label.apply(text: Constants.accountTitle, fontSize: Constants.accountTitleFontSize, fontWeight: .bold)
    }()
    
    private lazy var accountSubtitle: UILabel = {
        Registration.Label.apply(text: Constants.accountSubtitle, fontSize: Constants.accountSubtitleFontSize, fontWeight: .light)
    }()
    
    private lazy var nameTextField: LabeledTextField = {
        let textField = LabeledTextField()
        let viewState = LabeledTextField.ViewState(placeholder: Constants.nameTextFieldPlaceholder, isPassword: false)
        textField.render(with: viewState)
        return textField
    }()
    
    private lazy var emailTextField: LabeledTextField = {
        let textField = LabeledTextField()
        let viewState = LabeledTextField.ViewState(placeholder: Constants.emailFieldPlaceholder, isPassword: false)
        textField.render(with: viewState)
        return textField
    }()
    
    private lazy var passwordTextField: LabeledTextField = {
        let textField = LabeledTextField()
        let viewState = LabeledTextField.ViewState(placeholder: Constants.passwordFieldPlaceholder, isPassword: true)
        textField.render(with: viewState)
        return textField
    }()
    
    private lazy var confirmationPasswordTextField: LabeledTextField = {
        let textField = LabeledTextField()
        let viewState = LabeledTextField.ViewState(placeholder: Constants.confirmationPasswordFieldPlaceholder, isPassword: true)
        textField.render(with: viewState)
        return textField
    }()
    
    private lazy var registrationButton: UIButton = {
        Login.Button.apply(title: Constants.registrationButtonTitle)
    }()
    
    private lazy var alreadyMemberLabel: UILabel = {
        Login.Title.applyLink(text: Constants.alreadyMemberLabelTitle,
                              clickableText: Constants.alreadyMemberClickableText,
                              target: self,
                              action: #selector(loginButtonTapped))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupAutoLayout()
        setupBindings()
    }
    
    func checkValidation(_ errors: RegistrationErrors) {
        successfullyValidateFields()
        
        errors.errors.forEach { [weak self] error in
            guard let self = self else { return }
            
            switch error {
            case .username(let error):
                self.nameTextField.subtitle = error
                self.nameTextField.isError = true
            case .email(let error):
                self.emailTextField.subtitle = error
                self.emailTextField.isError = true
            case .password(let error):
                self.passwordTextField.subtitle = error
                self.passwordTextField.isError = true
            case .confirmationPassword(let error):
                self.confirmationPasswordTextField.subtitle = error
                self.confirmationPasswordTextField.isError = true
            }
        }
    }
    
    func successfullyValidateFields(error: Error? = nil) {
        if let error = error {
            callValidationAlert(with: error)
        } else {
            [nameTextField, emailTextField, passwordTextField, confirmationPasswordTextField].forEach { $0.isError = false }
        }
    }
    
    private func callValidationAlert(with error: Error) {
        let alert = UIAlertController(title: Constants.registrationErrorTitle, message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.alertAction, style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    private func setupSubviews() {
        view.backgroundColor = GeneralStyle.mainBackgroundColor
        view.addSubviewAndDisableAutoresizing(registrationStackView)
        
        registrationStackView.addArrangedSubview(accountTitle)
        registrationStackView.addArrangedSubview(accountSubtitle)
        registrationStackView.addArrangedSubview(nameTextField)
        registrationStackView.addArrangedSubview(emailTextField)
        registrationStackView.addArrangedSubview(passwordTextField)
        registrationStackView.addArrangedSubview(confirmationPasswordTextField)
        registrationStackView.addArrangedSubview(registrationButton)
        registrationStackView.addArrangedSubview(alreadyMemberLabel)
        
        applyHeight(components: [nameTextField, emailTextField, passwordTextField, confirmationPasswordTextField, registrationButton], constant: Constants.componentsHeight)
    }
    
    private func setupBindings() {
        registrationButton.touchUpInsidePublisher()
            .sink { [weak self] in
                guard let username = self?.nameTextField.text,
                      let email = self?.emailTextField.text,
                      let password = self?.passwordTextField.text,
                      let confirmationPassword = self?.confirmationPasswordTextField.text else { return }
                
                let user = RegisteredUser(username: username, email: email, password: password, confirmationPassword: confirmationPassword)
                
                self?.registrationButtonTapped(user: user)
            }.store(in: &subscriptions)
    }
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            registrationStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registrationStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            registrationStackView.widthAnchor.constraint(equalToConstant: LoginConstants.componentsWidth),
        ])
    }
    
    private func registrationButtonTapped(user: RegisteredUser) {
        presenter?.register(user: user)
    }
    
    @objc private func loginButtonTapped() {
        presenter?.navigateLogin()
    }
}
