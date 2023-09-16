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
    let servings: ServingsWrapper
    
    enum CodingKeys: String, CodingKey {
        case foodId = "food_id"
        case foodName = "food_name"
        case foodType = "food_type"
        case foodUrl = "food_url"
        case servings
    }
}

struct ServingsWrapper: Decodable {
    let serving: Serving
}

struct Serving: Decodable {
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

struct Ingredient {
    let id: String?
    let name: String
    let url: String
}
