//
//  Nutrient.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 11.03.2023.
//

import Foundation
import CoreData

@objc(Nutrient)
class Nutrient: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case unit
        case label
        case quantity
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
        label = try container.decode(String.self, forKey: .label)
        unit = try container.decode(String.self, forKey: .unit)
        quantity = try container.decode(Double.self, forKey: .quantity)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(label, forKey: .label)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(unit, forKey: .unit)
    }
}
