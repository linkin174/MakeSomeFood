//
//  FavoritesWorker.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 02.03.2023.
//

import Foundation

protocol FavoritesWorkerProtocol {
    func getFavoriteStatus(for recipe: Recipe) -> Bool
    func setFavoriteStatus(for recipe: Recipe, state: Bool)
    init(storageService: StoringProtocol)
}

final class FavoritesWorker: FavoritesWorkerProtocol {

    private let storageService: StoringProtocol

    func getFavoriteStatus(for recipe: Recipe) -> Bool {
        storageService.getFavoriteState(for: recipe)
    }

    func setFavoriteStatus(for recipe: Recipe, state: Bool) {
        storageService.saveFavoriteState(for: recipe, state: state)
    }

    func getFavoriteRecipes() -> [Recipe] {
        storageService.loadFavorites()
    }

    init(storageService: StoringProtocol) {
        self.storageService = storageService
    }
}
