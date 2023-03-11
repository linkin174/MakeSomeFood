//
//  Digest.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 11.03.2023.
//

import Foundation
import CoreData

@objc(Digest)
class Digest: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case label
        case total
        case daily
        case unit
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
        daily = try container.decode(Double.self, forKey: .daily)
        total = try container.decode(Double.self, forKey: .total)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(label, forKey: .label)
        try container.encode(unit, forKey: .unit)
        try container.encode(daily, forKey: .daily)
        try container.encode(total, forKey: .total)
    }
}
