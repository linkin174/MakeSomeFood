//
//  Recipie.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 14.02.2023.
//
import Foundation

protocol PropertieLoopable {
    func allProperties() -> [String: Any]
}

extension PropertieLoopable {
    func allProperties() -> [String: Any] {
        var result: [String: Any] = [:]
        let mirror = Mirror(reflecting: self)
        guard let style = mirror.displayStyle, style == .struct || style == .class else { return result }
        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }
            result[property] = value
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
            case from = "from"
            case to = "to"
            case count = "count"
            case links = "_links"
            case hits = "hits"
        }
}

// MARK: - Hit

struct Hit: Codable {
    let recipe: Recipe
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

struct Recipe: Codable {
    let uri: String?
    let label: String
    let image: String
    let images: Images?
    let source: String?
    let url: String?
    let shareAs: String?
    let yield: Double?
    let dietLabels: [String]?
    let healthLabels: [String]?
    let cautions: [String]?
    let ingredientLines: [String]?
    let ingredients: [Ingredient]?
    let calories: Double?
    let totalWeight: Double?
    let totalTime: Double?
    let cuisineType: [String]?
    let dishType: [String]?
    let totalNutrients: TotalNutrients?
    let totalDaily: TotalNutrients?
    let glycemicIndex: Int?
    let digest: [Digest]?
    let mealType: [String]?
}

struct TotalNutrients: Codable, PropertieLoopable {
//    let enercKcal: Nutrient?
    let fat: Nutrient?
//    let fasat: Nutrient?
//    let fatrn: Nutrient?
//    let fams: Nutrient?
//    let fapu: Nutrient?
    let chocdf: Nutrient?
//    let chocdfNet: Nutrient?
    let fibtg: Nutrient?
//    let sugar: Nutrient?
//    let sugarAdded: Nutrient?
    let procnt: Nutrient?
    let chole: Nutrient?
    let na: Nutrient?
    let ca: Nutrient?
    let mg: Nutrient?
    let k: Nutrient?
//    let fe: Nutrient?
//    let zn: Nutrient?
//    let p: Nutrient?
//    let vitaRae: Nutrient?
    let vitc: Nutrient?
//    let thia: Nutrient?
//    let ribf: Nutrient?
//    let nia: Nutrient?
    let vitb6A: Nutrient?
//    let foldfe: Nutrient?
//    let folfd: Nutrient?
//    let folac: Nutrient?
    let vitb12: Nutrient?
    let vitd: Nutrient?
//    let tocpha: Nutrient?
//    let vitk1: Nutrient?
//    let sugarAlcohol: Nutrient?
//    let water: Nutrient?

    enum CodingKeys: String, CodingKey {
//        case enercKcal = "ENERC_KCAL"
        case fat = "FAT"
//        case fasat = "FASAT"
//        case fatrn = "FATRN"
//        case fams = "FAMS"
//        case fapu = "FAPU"
        case chocdf = "CHOCDF"
//        case chocdfNet = "CHOCDF.net"
        case fibtg = "FIBTG"
//        case sugar = "SUGAR"
//        case sugarAdded = "SUGAR.added"
        case procnt = "PROCNT"
        case chole = "CHOLE"
        case na = "NA"
        case ca = "CA"
        case mg = "MG"
        case k = "K"
//        case fe = "FE"
//        case zn = "ZN"
//        case p = "P"
//        case vitaRae = "VITA_RAE"
        case vitc = "VITC"
//        case thia = "THIA"
//        case ribf = "RIBF"
//        case nia = "NIA"
        case vitb6A = "VITB6A"
//        case foldfe = "FOLDFE"
//        case folfd = "FOLFD"
//        case folac = "FOLAC"
        case vitb12 = "VITB12"
        case vitd = "VITD"
//        case tocpha = "TOCPHA"
//        case vitk1 = "VITK1"
//        case sugarAlcohol = "Sugar.alcohol"
//        case water = "WATER"
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
    let tag: String?
    let schemaOrgTag: String?
    let total: Double?
    let hasRdi: Bool?
    let daily: Double?
    let unit: String?
}

// MARK: - Images

struct Images: Codable {
    let thumbnail: ImageSize?
    let small: ImageSize?
    let regular: ImageSize?
    let large: ImageSize?
}

// MARK: - Large

struct ImageSize: Codable {
    let url: String?
    let width: Int?
    let height: Int?
}

// MARK: - Ingredient

struct Ingredient: Codable {
    let text: String?
    let quantity: Double?
    let measure: String?
    let food: String?
    let weight: Double?
    let foodCategory: String?
    let foodId: String?
    let image: String?
}
