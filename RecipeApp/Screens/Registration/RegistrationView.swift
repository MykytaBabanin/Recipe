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
    var presenter: RegistrationPresenterProtocol?
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var registrationStackView: UIStackView = {
        Registration.StackView.apply()
    }()
    
    private lazy var createAccountTitle: UILabel = {
        Registration.Label.apply(text: "Create Account", fontSize: 20, fontWeight: .bold)
    }()
    
    private lazy var createAccountSubtitle: UILabel = {
        Registration.Label.apply(text: "Let’s help you set up your account,\nit won’t take long.", fontSize: 11, fontWeight: .light)
    }()
    
    private lazy var nameTextField: LabeledTextField = {
        let textField = LabeledTextField()
        let viewState = LabeledTextField.ViewState(placeholder: "Enter name", isPassword: false)
        textField.render(with: viewState)
        return textField
    }()
    
    private lazy var emailTextField: LabeledTextField = {
        let textField = LabeledTextField()
        let viewState = LabeledTextField.ViewState(placeholder: "Enter email", isPassword: false)
        textField.render(with: viewState)
        return textField
    }()
    
    private lazy var passwordTextField: LabeledTextField = {
        let textField = LabeledTextField()
        let viewState = LabeledTextField.ViewState(placeholder: "Enter password", isPassword: true)
        textField.render(with: viewState)
        return textField
    }()
    
    private lazy var confirmationPasswordTextField: LabeledTextField = {
        let textField = LabeledTextField()
        let viewState = LabeledTextField.ViewState(placeholder: "Enter confirmation password", isPassword: true)
        textField.render(with: viewState)
        return textField
    }()
    
    private lazy var registrationButton: UIButton = {
        Login.Button.apply(title: "Sign up")
    }()
    
    private lazy var alreadyMemberLabel: UILabel = {
        Login.Title.applyLink(text: "Already a member?",
                              clickableText: "Sign In",
                              target: self,
                              action: #selector(loginButtonTapped))
    }()
    
    private lazy var separatorLabel: UILabel = {
        Login.Title.apply(text: "Or Sign In With",
                          fontSize: 11,
                          textAlignment: .center,
                          textColor: UIColor(hex: "#D9D9D9"))
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
        let alert = UIAlertController(title: "Registration Error", message: error?.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    private func setupSubviews() {
        view.backgroundColor = .white
        view.addSubviewAndDisableAutoresizing(registrationStackView)
        
        registrationStackView.addArrangedSubview(createAccountTitle)
        registrationStackView.addArrangedSubview(createAccountSubtitle)
        registrationStackView.addArrangedSubview(nameTextField)
        registrationStackView.addArrangedSubview(emailTextField)
        registrationStackView.addArrangedSubview(passwordTextField)
        registrationStackView.addArrangedSubview(confirmationPasswordTextField)
        registrationStackView.addArrangedSubview(registrationButton)
        registrationStackView.addArrangedSubview(separatorLabel)
        registrationStackView.addArrangedSubview(alreadyMemberLabel)
        
        applyHeight(components: [nameTextField, emailTextField, passwordTextField, confirmationPasswordTextField, registrationButton], constant: 55)
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
