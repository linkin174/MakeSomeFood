//
//  Recipie.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 14.02.2023.
//
import Foundation

protocol PropertyIterable {
    func allProperties() -> [String: Any]
}

extension PropertyIterable {
    func allProperties() -> [String: Any] {
        var result: [String: Any] = [:]
        let mirror = Mirror(reflecting: self)
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
           return result
        }
        for (label, value) in mirror.children {
            guard let label else {
                continue
            }
            result[label] = value
        }
        return result
    }
}

// MARK: - RecipeResponse

struct RecipeResponse: Codable {
    let from: Int?
    let to: Int?
    let count: Int?
    let links: Links?
    let hits: [Hit]

    enum CodingKeys: String, CodingKey {
        case from
        case to
        case count
        case links = "_links"
        case hits
    }
}

// MARK: - Hit

struct Hit: Codable {
    let recipe: Recipe?
//    let links: Links?
}

// MARK: - Links

struct Links: Codable {
    let linksSelf: Next?
    let next: Next?
}

// MARK: - Next

struct Next: Codable {
    let href: String?
    let title: String?
}

// MARK: - Recipe

struct Recipe: Codable, Equatable {
    let label: String?
    let image: String?
    let images: Images?
    let source: String?
    let url: String?
    let uri: String?
    let shareAs: String?
    let yield: Double?
    let dietLabels: [String]?
    let healthLabels: [String]?
    let cautions: [String]?
    let ingredients: [Ingredient]?
    let calories: Double?
    let totalWeight: Double?
    let totalTime: Double?
    let cuisineType: [String]?
    let dishType: [String]?
    let totalNutrients: TotalNutrients?
    let totalDaily: TotalNutrients?
    let digest: [Digest]?
    let mealType: [String]?

    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.shareAs == rhs.shareAs
    }
}

struct TotalNutrients: Codable {
    let fibtg: Nutrient?
    let chole: Nutrient?

    enum CodingKeys: String, CodingKey {
        case chole = "CHOLE"
        case fibtg = "FIBTG"
    }
}

struct Nutrient: Codable, Equatable {
    let label: String?
    let quantity: Double?
    let unit: String?
}

// MARK: - Digest

struct Digest: Codable {
    let label: String?
    let total: Double?
    let daily: Double?
    let unit: String?
}

// MARK: - Images

struct Images: Codable, PropertyIterable {
    let thumbnail: ImageSize?
    let small: ImageSize?
    let regular: ImageSize?
    let large: ImageSize?

    enum CodingKeys: String, CodingKey {
        case thumbnail = "THUMBNAIL"
        case small = "SMALL"
        case regular = "REGULAR"
        case large = "LARGE"
    }
}

// MARK: - Large
struct ImageSize: Codable {
    let url: String?
    let width: Double?
    let height: Double?
}

// MARK: - Ingredient

struct Ingredient: Codable, Equatable {
    let text: String?
    let quantity: Double?
    let measure: String?
    let food: String?
    let weight: Double?
    let foodCategory: String?
    let foodId: String?
    let image: String?
}
