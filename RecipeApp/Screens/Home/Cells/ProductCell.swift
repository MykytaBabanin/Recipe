//
//  ProductCell.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 04/09/2023.
//

import UIKit

final class ProductCell: UICollectionViewCell {
    static let identifier = "productCellIdentifier"
    
    private var imageView: UIImageView = {
        var image = UIImageView()
        return image
    }()
    
    private let title: UILabel = {
        let title = UILabel()
        return title
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Time"
        return label
    }()
    
    private let timeValueLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String,
                   imagePath: UIImage,
                   timeValueText: String) {
        title.text = text
        imageView.image = imagePath
        timeValueLabel.text = timeValueText
    }
    
    private func setupSubviews() {
        [title, imageView, timeValueLabel, timeLabel, saveButton].forEach { view in
            contentView.addSubviewAndDisableAutoresizing(view)
        }
    }
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            title.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
            
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: timeValueLabel.topAnchor),
            
            timeValueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            timeValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
