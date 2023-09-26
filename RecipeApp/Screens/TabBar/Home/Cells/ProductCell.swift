//
//  ProductCell.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 04/09/2023.
//

import UIKit
import SwipeCellKit

enum ProductCellConstants {
    static let productCellWidthIset: CGFloat = 30
    static let productCellHeight: CGFloat = 70
    static let productCellCornerRadius: CGFloat = 10
    static let productCellShadowRadius: CGFloat = 2.0
    static let productCellShadowOpacity: Float = 0.1
    static let productCellIdentifier = "ProductCell"
    static let disabledTileColor = UIColor.white
    static let shadowOffset = CGSize(width: 0, height: 3)
    static let nameLabelInset: CGFloat = 8
    static let empty = ""
}

final class ProductCell: SwipeCollectionViewCell {
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        Home.ProductLabel.apply(label)
        return label
    }()
    
    static let identifier = ProductCellConstants.productCellIdentifier
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupSubviews()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with food: Food?) {
        nameLabel.text = food?.foodName
    }
}
    
    private extension ProductCell {
        func setupStyle() {
            layer.cornerRadius = ProductCellConstants.productCellCornerRadius
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: ProductCellConstants.shadowOffset.width, height: ProductCellConstants.shadowOffset.height)
            layer.masksToBounds = false
            layer.shadowRadius = ProductCellConstants.productCellShadowRadius
            layer.shadowOpacity = ProductCellConstants.productCellShadowOpacity
            backgroundColor = ProductCellConstants.disabledTileColor
        }
        
        func setupSubviews() {
            addSubviewAndDisableAutoresizing(nameLabel)
        }
        
        func setupAutoLayout() {
            NSLayoutConstraint.activate([
                nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                nameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
                nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
            ])
            let centerXConstraint = nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            centerXConstraint.priority = .defaultHigh
            centerXConstraint.isActive = true
        }
    }
