//
//  CalorieCounterCell.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 25/09/2023.
//

import UIKit

final class CalorieCounterCell: UICollectionViewCell {
    enum CalorieCounterConstants {
        static let productCellIdentifier = "CalorieCounterCell"
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        Home.ProductLabel.apply(label)
        return label
    }()
    
    private lazy var servingLabel: UILabel = {
        let label = UILabel()
        CalorieCounter.DescriptionLabel.apply(label)
        return label
    }()
    
    static let identifier = CalorieCounterConstants.productCellIdentifier
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupSubviews()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with food: FirebaseFoodResponse) {
        nameLabel.text = food.foodName
    }
    
    func configure(with serving: Serving) {
        var nutrientStrings: [String] = []
        
        if let calories = serving.calories {
            nutrientStrings.append(ServingConstants.calories + "\(calories)")
        }
        
        if let calcium = serving.calcium {
            nutrientStrings.append(ServingConstants.calcium + "\(calcium)")
        }
        
        if let fat = serving.fat {
            nutrientStrings.append(ServingConstants.fat + "\(fat)")
        }
        
        if let fiber = serving.fiber {
            nutrientStrings.append(ServingConstants.fiber + "\(fiber)")
        }
        
        if let carbohydrate = serving.carbohydrate {
            nutrientStrings.append(ServingConstants.carbohydrate + "\(carbohydrate)")
        }
        
        servingLabel.text = nutrientStrings.joined(separator: "\n")
    }
}

private extension CalorieCounterCell {
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
        addSubviewAndDisableAutoresizing(servingLabel)
    }
    
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            
            servingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            servingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            servingLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
