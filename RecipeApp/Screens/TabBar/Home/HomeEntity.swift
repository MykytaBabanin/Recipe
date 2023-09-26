//
//  HomeEntity.swift
//  RecipeApp
//
//  Created by Никита Бабанин on 09/09/2023.
//

import Foundation

//MARK: Search V2

struct FoodSearch: Decodable {
    let foods: FoodWrapper
}

struct FoodWrapper: Decodable {
    let food: [Food]
}

struct Food: Decodable, Hashable {
    let foodId: String
    let foodName: String
    let foodUrl: String
    
    enum CodingKeys: String, CodingKey {
        case foodId = "food_id"
        case foodName = "food_name"
        case foodUrl = "food_url"
    }
}

//MARK: Get food by Id

struct FoodResponse: Decodable {
    let food: FoodDetails
}

struct FoodDetails: Decodable {
    let foodId: String
    let foodName: String
    let foodType: String
    let foodUrl: String
    let servings: Servings
    
    enum CodingKeys: String, CodingKey {
        case foodId = "food_id"
        case foodName = "food_name"
        case foodType = "food_type"
        case foodUrl = "food_url"
        case servings
    }
}

struct Serving: Codable {
    let calcium: String?
    let calories: String?
    let carbohydrate: String?
    let cholesterol: String?
    let fat: String?
    let fiber: String?
    let protein: String?
    let sodium: String?
    let sugar: String?
}

struct Servings: Decodable {
    var serving: [Serving]?
    var servingDictionary: Serving?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.serving = try container.decodeIfPresent([Serving].self, forKey: .serving)
            self.servingDictionary = nil
        } catch DecodingError.typeMismatch {
            self.servingDictionary = try container.decodeIfPresent(Serving.self, forKey: .serving)
            self.serving = nil
        } catch {
            throw DecodingError.dataCorruptedError(forKey: .serving, in: container, debugDescription: "Mismatched types")
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case serving
    }
}

struct FirebaseFoodResponse: Codable {
    let foodId: String
    let foodName: String
    let foodType: String
    let foodUrl: String
    let servings: [Serving]

    enum CodingKeys: String, CodingKey {
        case foodId = "food_id"
        case foodName = "food_name"
        case foodType = "food_type"
        case foodUrl = "food_url"
        case servings
    }
}

