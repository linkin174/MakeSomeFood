//
//  StorageService.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 15.02.2023.
//

import Foundation

struct Filters: Codable {
    let searchQuery: String?
    let dietType: String
    let cuisineType: String
    let mealType: String
    let dishType: String
    let random: Bool
}

final class StorageService {

    var dietList = [
        "Any",
        "Balanced",
        "High-Fiber",
        "High-Protein",
        "Low-Carb",
        "Low-Fat",
        "Low-Sodium"
    ]

    var cuisineTypes = [
        "Any",
        "American",
        "Asian",
        "British",
        "Caribbean",
        "Central Europe",
        "Chinese",
        "Eastern Europe",
        "French",
        "Indian",
        "Italian",
        "Japanese",
        "Kosher",
        "Mediterranian",
        "Mexican",
        "Middle Eastern",
        "Nordin",
        "South American",
        "South East Asian"
    ]

    var mealTypes = [
        "Any",
        "Breakfast",
        "Dinner",
        "Lunch",
        "Snack",
        "Teatime"
    ]

    var dishTypes = [
        "Any",
        "Biscuits and Cookies",
        "Bread",
        "Cereals",
        "Condiments and Sauces",
        "Desserts",
        "Drinks",
        "Main Course",
        "Pancake",
        "Preps",
        "Preserve",
        "Salad",
        "Sandwiches",
        "Side Dish",
        "Soup",
        "Starter",
        "Sweets"
    ]

    private let userDefaults = UserDefaults.standard

    func loadFilters() -> Filters {
        guard
            let data = userDefaults.data(forKey: "filters"),
            let filters = try? JSONDecoder().decode(Filters.self, from: data)
        else {
            return Filters(searchQuery: nil,
                           dietType: dietList[0],
                           cuisineType: cuisineTypes[0],
                           mealType: mealTypes[0],
                           dishType: dishTypes[0],
                           random: false)
        }
        return filters
    }

    func save(filters: Filters) {
        guard let data = try? JSONEncoder().encode(filters) else { return }
        userDefaults.set(data, forKey: "filters")
    }
}
