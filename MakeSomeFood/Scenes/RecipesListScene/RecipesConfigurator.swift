//
//  RecipesConfigurator.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 28.02.2023.
//

import Foundation
import Swinject

final class RecipesConfigurator {

    // MARK: - Static Properties

    static let shared = RecipesConfigurator()

    // MARK: - Private properties
    private var containter: Container = {
        let container = Container()

        container.register(NetworkService.self) { _ in
            NetworkService()
        }

        container.register(StorageService.self) { _ in
            StorageService()
        }

        container.register(FetcherService.self) { resolver in
            FetcherService(networkService: resolver.resolve(NetworkService.self),
                           storageService: resolver.resolve(StorageService.self))
        }

        return container
    }()

    // MARK: - Initializers

    private init() {}

    // MARK: - Public methods

    func configure(with viewController: RecipesViewController) {
        let interactor = RecipesInteractor(fetcherService: FetcherService(networkService: NetworkService(), storageService: StorageService()))
        let presenter = RecipesPresenter()
        let router = RecipesRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
