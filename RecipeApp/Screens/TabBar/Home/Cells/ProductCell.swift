//
//  ProductCell.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 04/09/2023.
//

import UIKit
import Lottie

enum ProductCellConstants {
    static let productCellWidthIset: CGFloat = 30
    static let productCellHeight: CGFloat = 70
    static let skeletonAnimationView = "skeleton"
    static let productCellCornerRadius: CGFloat = 30
    static let productCellShadowRadius: CGFloat = 4.0
    static let productCellShadowOpacity: Float = 0.2
    static let productCellIdentifier = "ProductCell"
    static let disabledTileColor = GeneralStyle.mainAppColor
    static let shadowOffset = CGSize(width: 0, height: 5)
    static let nameLabelInset: CGFloat = 8
    static let empty = ""
}

final class ProductCell: UICollectionViewCell {
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        Home.ProductLabel.apply(label)
        return label
    }()
    
    static let identifier = ProductCellConstants.productCellIdentifier
    
    private let animationView = AnimatedItem(animation: ProductCellConstants.skeletonAnimationView, speed: 0.3)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        animationView.play()
        setupStyle()
        setupSubviews()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with food: Food?) {
        if let food = food {
            animationView.animationView?.isHidden = true
            animationView.pause()
            nameLabel.text = food.foodName
        } else {
            animationView.animationView?.isHidden = false
            animationView.play()
            nameLabel.text = ProductCellConstants.empty
        }
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
            addSubviewAndDisableAutoresizing(animationView.animationView ?? UIView())
            addSubviewAndDisableAutoresizing(nameLabel)
        }
        
        func setupAutoLayout() {
            animationView.animationView?.pin(toEdges: self)
            
            NSLayoutConstraint.activate([
                nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                nameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: ProductCellConstants.nameLabelInset),
                nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -ProductCellConstants.nameLabelInset)
            ])
            let centerXConstraint = nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            centerXConstraint.priority = .defaultHigh
            centerXConstraint.isActive = true
        }
    }
