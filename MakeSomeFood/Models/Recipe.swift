//
//  Recipe.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 11.03.2023.
//

import Foundation
import CoreData

@objc(Recipe)
class Recipe: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case uri
        case label
        case image
        case images
        case source
        case url
        case shareAs
        case yield
        case dietLabels
        case healthLabels
        case cautions
        case ingredients
        case calories
        case co2EmissionsClass
        case totalWeight
        case cuisineLabels = "cuisineType"
        case mealLabels = "mealType"
        case dishLabels = "dishType"
        case tags
        case externalId
        case totalNutrients
        case totalDaily
        case digest
        case totalTime
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
        calories = try container.decode(Double.self, forKey: .calories)
        totalTime = try container.decode(Double.self, forKey: .totalTime)
        totalWeight = try container.decode(Double.self, forKey: .totalWeight)
        yield = try container.decode(Double.self, forKey: .yield)
        image = try container.decode(String.self, forKey: .image)
        label = try container.decode(String.self, forKey: .label)
        shareAs = try container.decode(String.self, forKey: .shareAs)
        source = try container.decode(String.self, forKey: .source)
        uri = try container.decode(String.self, forKey: .uri)
        url = try container.decode(String.self, forKey: .url)
        cautions = try container.decode([String].self, forKey: .cautions)
        cuisineLabels = try container.decode([String].self, forKey: .cuisineLabels)
        dietLabels = try container.decode([String].self, forKey: .dietLabels)
        dishLabels = try container.decode([String].self, forKey: .dishLabels)
        healthLabels = try container.decode([String].self, forKey: .healthLabels)
        mealLabels = try container.decode([String].self, forKey: .mealLabels)
        totalDaily = try container.decode(TotalNutrients.self, forKey: .totalDaily)
        totalNutrients = try container.decode(TotalNutrients.self, forKey: .totalNutrients)
        images = try container.decode(Images.self, forKey: .images)
        digest = try container.decode([Digest].self, forKey: .digest)
        ingredients = try container.decode([Ingredient].self, forKey: .ingredients)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(calories, forKey: .calories)
        try container.encode(totalTime, forKey: .totalTime)
        try container.encode(totalWeight, forKey: .totalWeight)
        try container.encode(yield, forKey: .yield)
        try container.encode(image, forKey: .image)
        try container.encode(label, forKey: .label)
        try container.encode(shareAs, forKey: .shareAs)
        try container.encode(source, forKey: .source)
        try container.encode(uri, forKey: .uri)
        try container.encode(url, forKey: .url)
        try container.encode(cautions, forKey: .cautions)
        try container.encode(cuisineLabels, forKey: .cuisineLabels)
        try container.encode(dietLabels, forKey: .dietLabels)
        try container.encode(dishLabels, forKey: .dishLabels)
        try container.encode(healthLabels, forKey: .healthLabels)
        try container.encode(mealLabels, forKey: .mealLabels)
        try container.encode(totalDaily, forKey: .totalDaily)
        try container.encode(totalNutrients, forKey: .totalNutrients)
        try container.encode(images, forKey: .images)
        try container.encode(digest, forKey: .digest)
        try container.encode(ingredients, forKey: .ingredients)
    }
}
