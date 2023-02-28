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
//    func doSomethingElse(request: Favorites.SomethingElse.Request)
}

protocol FavoritesDataStore {
    //var name: String { get set }
}

final class FavoritesInteractor: FavoritesBusinessLogic, FavoritesDataStore {

    // MARK: - Public properties

    var presenter: FavoritesPresentationLogic?

    // MARK: - Private Properties

    private let storageService: StorageService

    // MARK: - Initializers

    init(storageService: StorageService) {
        self.storageService = storageService
    }

    // MARK: - Interaction Logic
    
    func start() {
        let favorites = storageService.loadFavorites()
        print(favorites.map { $0.label })
        let response = Favorites.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
