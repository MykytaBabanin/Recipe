//
//  WelcomeTitleView.swift
//  RecipeApp
//
//  Created by Mykyta Babanin on 31.08.2023.
//

import UIKit
import PhotosUI
import Combine

protocol HomeHeaderViewDelegate: AnyObject {
    func presentPicker(_ picker: PHPickerViewController)
}

final class HomeHeaderView: UIView {
    
    private var subscriptions = Set<AnyCancellable>()
    weak var delegate: HomeHeaderViewDelegate?
    
    private let homeTitle: UILabel = {
        let label = UILabel()
        Home.Title.apply(title: label)
        return label
    }()
    
    private let homeSubtitle: UILabel = {
        let label = UILabel()
        Home.Title.apply(subtitle: label)
        return label
    }()
    
    private lazy var selectEmojiButton: UIButton = {
        let button = UIButton()
        Home.Button.apply(selectEmojiButton: button)
        return button
    }()
    
    private lazy var homeStackView: UIStackView = {
        let stackView = UIStackView()
        Home.StackView.apply(stackView: stackView)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupSubviews()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeHeaderView {
    func setupView() {
        homeStackView.addArrangedSubview(homeTitle)
        homeStackView.addArrangedSubview(homeSubtitle)
        addSubviewAndDisableAutoresizing(selectEmojiButton)
        addSubviewAndDisableAutoresizing(homeStackView)
    }
    
    func setupSubviews() {
        NSLayoutConstraint.activate([
            homeStackView.trailingAnchor.constraint(equalTo: selectEmojiButton.leadingAnchor),
            homeStackView.topAnchor.constraint(equalTo: topAnchor),
            homeStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            homeStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            selectEmojiButton.topAnchor.constraint(equalTo: topAnchor),
            selectEmojiButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            selectEmojiButton.heightAnchor.constraint(equalToConstant: 60),
            selectEmojiButton.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func setupBindings() {
        selectEmojiButton.touchUpInsidePublisher()
            .sink { [weak self] in
                self?.openPHPicker()
            }.store(in: &subscriptions)
    }
    
    func openPHPicker() {
        var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        phPickerConfig.selectionLimit = 1
        phPickerConfig.filter = PHPickerFilter.any(of: [.images, .livePhotos])
        let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
        phPickerVC.delegate = self
        delegate?.presentPicker(phPickerVC)
    }
    
    func setupAvatarImage(with image: UIImage) {
        selectEmojiButton.setImage(image, for: .normal)
        
        selectEmojiButton.imageView?.contentMode = .scaleAspectFill
        selectEmojiButton.layer.masksToBounds = true
        selectEmojiButton.layer.cornerRadius = 20
    }
}

extension HomeHeaderView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: .none)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                DispatchQueue.main.async {
                    self.setupAvatarImage(with: image)
                }
            }
        }
    }
}
