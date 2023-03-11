//
//  Images.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 11.03.2023.
//

import Foundation
import CoreData

@objc(Images)
class Images: NSManagedObject, Codable, PropertyIterable {

    enum CodingKeys: String, CodingKey {
        case thumbnail = "THUMBNAIL"
        case small = "SMALL"
        case regular = "REGULAR"
        case large = "LARGE"
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
        thumbnail = try container.decode(ImageSize.self, forKey: .thumbnail)
        small = try container.decode(ImageSize.self, forKey: .small)
        regular = try container.decode(ImageSize.self, forKey: .regular)
        #warning("i don't know why large is not decoding")
//        self.large = try container.decode(ImageSize.self, forKey: .large)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(thumbnail, forKey: .thumbnail)
        try container.encode(small, forKey: .small)
        try container.encode(regular, forKey: .regular)
//        try container.encode(large, forKey: .large)
    }
}
