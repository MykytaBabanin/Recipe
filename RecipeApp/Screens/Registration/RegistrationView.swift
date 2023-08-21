//
//  RegistrationView.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 13.08.2023.
//

import UIKit

final class RegistrationView: UIViewController, Viewable {
    typealias PresenterType = RegistrationPresenter
    var presenter: PresenterType?
    
    private lazy var registrationStackView: UIStackView = {
        Registration.StackView.apply()
    }()
    
    private lazy var createAccountTitle: UILabel = {
        Registration.Label.apply(text: "Create Account", fontSize: 20, fontWeight: .bold)
    }()
    
    private lazy var createAccountSubtitle: UILabel = {
        Registration.Label.apply(text: "Let’s help you set up your account,\nit won’t take long.", fontSize: 11, fontWeight: .light)
    }()
    
    private lazy var nameTextField: UITextField = {
        Registration.TextField.apply(placeholder: "Enter name")
    }()
    
    private lazy var emailTextField: UITextField = {
        Registration.TextField.apply(placeholder: "Enter email")
    }()
    
    private lazy var passwordTextField: UITextField = {
        Registration.TextField.apply(placeholder: "Enter password", isSecure: true)
    }()
    
    private lazy var confirmationPasswordTextField: UITextField = {
        Registration.TextField.apply(placeholder: "Enter confirmation password", isSecure: true)
    }()
    
    private lazy var registrationButton: UIButton = {
        Login.Button.apply(title: "Sign up")
    }()
    
    private lazy var alreadyMemberLabel: UILabel = {
        Login.Title.apply(text: "Already a member?Sign In",
                                 fontSize: 11,
                                 textAlignment: .center,
                                 withLink: true,
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
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            registrationStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registrationStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            registrationStackView.widthAnchor.constraint(equalToConstant: LoginConstants.componentsWidth),
        ])
    }
    
    @objc private func loginButtonTapped() {
        presenter?.navigateLogin()
    }
}
