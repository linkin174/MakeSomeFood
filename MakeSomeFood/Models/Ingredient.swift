//
//  Ingredient.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 11.03.2023.
//

import Foundation
import CoreData


@objc(Ingredient)
class Ingredient: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case image
        case text
        case quantity
        case food
        case weight
        case foodId
        case foodCategory
    }

    required convenience init(from decoder: Decoder) throws {
        guard
            let infoKey = CodingUserInfoKey.managedObjectContext,
            let context = decoder.userInfo[infoKey] as? NSManagedObjectContext
        else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        image = try container.decode(String.self, forKey: .image)
        text = try container.decode(String.self, forKey: .text)
        quantity = try container.decode(Double.self, forKey: .quantity)
        food = try container.decode(String.self, forKey: .food)
        weight = try container.decode(Double.self, forKey: .weight)
        foodId = try container.decode(String.self, forKey: .foodId)
        foodCategory = try container.decode(String.self, forKey: .foodCategory)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(image, forKey: .image)
        try container.encode(text, forKey: .text)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(food, forKey: .food)
        try container.encode(weight, forKey: .weight)
        try container.encode(foodId, forKey: .foodId)
        try container.encode(foodCategory, forKey: .foodCategory)
    }
}
