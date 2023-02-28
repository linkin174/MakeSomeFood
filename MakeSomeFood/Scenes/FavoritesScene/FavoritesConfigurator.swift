//
//  FavoritesConfigurator.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 28.02.2023.
//

import Foundation
import Swinject

final class FavoritesConfigurator {

    // MARK: - Static properties

    static let shared = FavoritesConfigurator()

    // MARK: - Private properties
    private var containter: Container = {
        let container = Container()

        container.register(StorageService.self) { _ in
            StorageService()
        }

        return container
    }()

    // MARK: - Initializers

    private init() {}

    // MARK: - Public methods

    func configure(with viewController: FavoritesViewController) {
        guard let storageService = containter.resolve(StorageService.self) else { return }
        let interactor = FavoritesInteractor(storageService: storageService)
        let presenter = FavoritesPresenter()
        let router = FavoritesRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
