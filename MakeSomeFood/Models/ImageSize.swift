//
//  ImageSize.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 11.03.2023.
//

import Foundation
import CoreData

@objc(ImageSize)
class ImageSize: NSManagedObject, Codable, PropertyIterable {
    enum CodingKeys: String, CodingKey {
        case url
        case width
        case height
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
        height = try container.decode(Double.self, forKey: .height)
        width = try container.decode(Double.self, forKey: .width)
        url = try container.decode(String.self, forKey: .url)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url, forKey: .url)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
    }
}
