//
//  StorageService.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 15.02.2023.
//

import Foundation
import CoreData

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

    /// Diet types labels handled by API
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

    private let persistentContainer: NSPersistentContainer = {
        let containter = NSPersistentContainer(name: "MakeSomeFood")
        containter.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return containter
    }()

    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Public Methods

    /// Load saved filters by user
    /// - Returns: object of type ``Filters``
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

    /// Save filters to UserDefaults
    /// - Parameter filters: Object storing filtering data
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

    /// Return favorite state for given recipe and adds this recipe to database
    /// - Parameters:
    ///   - recipe: Object of type ``Recipe``
    ///   - state: state to save ``true`` or ``false``
    func saveFavoriteState(for recipe: Recipe, state: Bool) {
        guard let uri = recipe.uri else { return }
        userDefaults.set(state, forKey: uri)
        if state {
            addFavorite(recipe: recipe)
        } else {
            removeFavorite(recipe: recipe)
        }
    }

    /// Returns favorite state for given recipe
    /// - Parameter recipe: object of type ``Recipe``
    /// - Returns: boolean ``true`` for favorite state, ``false`` for opposite
    func getFavoriteState(for recipe: Recipe) -> Bool {
        guard let uri = recipe.uri else { return false }
        return userDefaults.bool(forKey: uri)
    }

    /// Return an array of saved favorite recipes
    /// - Returns: Array of ``Recipe`` or empty array
    func loadFavorites() -> [Recipe] {
        #warning("for test")
        guard
            let data = userDefaults.data(forKey: "favorites"),
            let recipes = try? JSONDecoder().decode([Recipe].self, from: data)
        else {
            return []
        }
        return recipes
    }

    // MARK: - Private methods

    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved \(nserror), \(nserror.userInfo)")
            }
        }
    }

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
