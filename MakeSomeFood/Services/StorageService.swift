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

protocol StoringProtocol {
    var dietTypes: [String] { get }
    var cuisineTypes: [String] { get }
    var mealTypes: [String] { get }
    var dishTypes: [String] { get }
    func loadFilters() -> Filters
    func save(filters: Filters)
    func save(ingredient: String)
    func remove(ingredient: String)
    func loadIngredients() -> [String]
    func loadFavorites() -> [Recipe]
    func saveFavoriteState(for recipe: Recipe, state: Bool)
    func getFavoriteState(for recipe: Recipe) -> Bool
}

final class StorageService: StoringProtocol {

    // MARK: - Public Properties

    var dietTypes = ["Any", "Balanced", "High-Fiber", "High-Protein", "Low-Carb", "Low-Fat", "Low-Sodium"]

    var cuisineTypes = ["Any", "American", "Asian", "British", "Caribbean", "Central Europe", "Chinese",
                        "Eastern Europe", "French", "Indian", "Italian", "Japanese", "Kosher", "Mediterranian",
                        "Mexican", "Middle Eastern", "Nordic", "South American", "South East Asian"]

    var mealTypes = ["Any", "Breakfast", "Dinner", "Lunch", "Snack", "Teatime"]

    var dishTypes = ["Any", "Biscuits and cookies", "Bread", "Cereals", "Condiments and sauces", "Desserts",
                     "Drinks", "Main course", "Pancake", "Preps", "Preserve", "Salad", "Sandwiches", "Side dish", "Soup",
                     "Starter", "Sweets"]

    // MARK: - Private Properties

    private let userDefaults = UserDefaults.standard

    // MARK: - Public Methods

    func loadFilters() -> Filters {
        guard
            let data = userDefaults.data(forKey: "filters"),
            let filters = try? JSONDecoder().decode(Filters.self, from: data)
        else {
            return Filters(searchQuery: nil,
                           dietType: dietTypes[0],
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

    func save(ingredient: String) {
        var ingredients = loadIngredients()
        ingredients.append(ingredient)
        guard let data = try? JSONEncoder().encode(ingredients) else { return }
        userDefaults.set(data, forKey: "ingredients")
    }

    func remove(ingredient: String) {
        var ingredients = loadIngredients()
        ingredients.removeAll(where: { $0 == ingredient })
        guard let data = try? JSONEncoder().encode(ingredients) else { return }
        userDefaults.set(data, forKey: "ingredients")
    }

    func loadIngredients() -> [String] {
        guard
            let data = userDefaults.data(forKey: "ingredients"),
            let ingredients = try? JSONDecoder().decode([String].self, from: data)
        else { return [] }
        return ingredients
    }

    func saveFavoriteState(for recipe: Recipe, state: Bool) {
        userDefaults.set(state, forKey: recipe.uri)
        if state {
            addFavorite(recipe: recipe)
        } else {
            removeFavorite(recipe: recipe)
        }
    }

    func getFavoriteState(for recipe: Recipe) -> Bool {
        userDefaults.bool(forKey: recipe.uri)
    }

    func loadFavorites() -> [Recipe] {
        guard
            let data = userDefaults.data(forKey: "favorites"),
            let recipes = try? JSONDecoder().decode([Recipe].self, from: data)
        else {
            return []
        }
        return recipes
    }

    #warning("migrate to coredata later")
    #warning("remove duplicating logic of decoding/encoding")
    #warning("save bools for keys as recipe name")
    private func addFavorite(recipe: Recipe) {
        var favorites = loadFavorites()
        favorites.append(recipe)
        guard let data = try? JSONEncoder().encode(favorites) else { return }
        userDefaults.set(data, forKey: "favorites")
    }

    private func removeFavorite(recipe: Recipe) {
        var favorites = loadFavorites()
        favorites.removeAll(where: { $0 == recipe })
        guard let data = try? JSONEncoder().encode(favorites) else { return }
        userDefaults.set(data, forKey: "favorites")
    }
}
