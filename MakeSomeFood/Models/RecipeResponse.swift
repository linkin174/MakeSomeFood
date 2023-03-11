//
//  Recipie.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 14.02.2023.
//
import CoreData
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

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}
