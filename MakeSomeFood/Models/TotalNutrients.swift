//
//  TotalNutrients.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 11.03.2023.
//

import Foundation
import CoreData

@objc(TotalNutrients)
class TotalNutrients: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case chole = "CHOLE"
        case fibtg = "FIBTG"
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
        chole = try container.decode(Nutrient.self, forKey: .chole)
        fibtg = try container.decode(Nutrient.self, forKey: .fibtg)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(chole, forKey: .chole)
        try container.encode(fibtg, forKey: .fibtg)
    }
}
