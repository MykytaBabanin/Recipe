//
//  LabeledLoginTextField.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 28.08.2023.
//

import UIKit

final class LabeledTextField: UIView {
    
    enum Constants {
        static let stackViewSpacing: CGFloat = 4
        static let subtitleLabelFontSize: CGFloat = 10
        static let numberOfLines = 1
        static let empty = ""
        static let errorBorderWidth: CGFloat = 1
        static let errorCornerRadius: CGFloat = 5
        static let nonErrorBorderWidth: CGFloat = 0
    }
    
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
            textField.layer.borderWidth = Constants.errorBorderWidth
            textField.layer.cornerRadius = Constants.errorCornerRadius
            
            subtitleLabel.textColor = .red
            subtitleLabel.text = subtitle
        } else {
            textField.layer.borderWidth = Constants.nonErrorBorderWidth
            subtitle = Constants.empty
        }
        
        subtitleLabel.isHidden = subtitle == Constants.empty
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
        
        stackView.pin(toEdges: self)
        
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
            
        subtitleLabel.font = GeneralStyle.setupMainAppFont(fontSize: Constants.subtitleLabelFontSize)
        subtitleLabel.numberOfLines = Constants.numberOfLines
        
        textField.autocapitalizationType = .none
        textField.layer.borderColor = UIColor.red.cgColor
        textField.borderStyle = .roundedRect
        
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(subtitleLabel)
    }
}
