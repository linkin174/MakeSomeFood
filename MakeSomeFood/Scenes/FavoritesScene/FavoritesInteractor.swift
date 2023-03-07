//
//  FavoritesInteractor.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 28.02.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FavoritesBusinessLogic {
    func start()
}

protocol FavoritesDataStore {
    var recipes: [Recipe] { get }
}

final class FavoritesInteractor: FavoritesBusinessLogic, FavoritesDataStore {

    // MARK: - Public properties

    var presenter: FavoritesPresentationLogic?
    var recipes: [Recipe] = []

    // MARK: - Private Properties

    private let storageService: StoringProtocol

    // MARK: - Initializers

    init(storageService: StoringProtocol) {
        self.storageService = storageService
    }

    // MARK: - Interaction Logic
    
    func start() {
        let worker = FavoritesWorker(storageService: storageService)
        recipes = worker.getFavoriteRecipes()
        let response = FavoritesList.ShowFavorites.Response(recipes: recipes)
        presenter?.presentFavorites(response: response)
    }
}
