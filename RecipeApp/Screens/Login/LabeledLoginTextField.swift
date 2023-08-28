//
//  LabeledLoginTextField.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 28.08.2023.
//

import UIKit

class LabeledTextField: UIView {
    struct ViewState {
        let placeholder: String
        let isPassword: Bool
    }
    private let textField = UITextField()
    private let subtitleLabel = UILabel()
    private let stackView = UIStackView()
    
    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    var delegate: UITextFieldDelegate {
        get {
            return textField.delegate!
        }
        set {
            textField.delegate = newValue
        }
    }
    
    var isError = false {
        didSet {
            changeState()
        }
    }
    
    var subtitle: String?

    private func changeState() {
        if isError {
            textField.layer.borderWidth = 1
            
            subtitleLabel.textColor = .red
            subtitleLabel.text = subtitle
        } else {
            textField.layer.borderWidth = 0
            subtitle = ""
        }
        
        subtitleLabel.isHidden = subtitle == ""
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render(with viewState: ViewState) {
        if let subtitle = subtitle {
            subtitleLabel.isHidden = false
            subtitleLabel.text = subtitle
        } else {
            subtitleLabel.isHidden = true
        }
        
        textField.isSecureTextEntry = viewState.isPassword
        textField.placeholder = viewState.placeholder
    }
    
    private func setupUI() {
        self.addSubviewAndDisableAutoresizing(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 8
            
        subtitleLabel.font = .systemFont(ofSize: 10)
        subtitleLabel.numberOfLines = 1
        
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.red.cgColor
        
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(subtitleLabel)
    }
}
