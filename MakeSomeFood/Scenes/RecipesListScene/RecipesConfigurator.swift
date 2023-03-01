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

        container.register(NetworkingProtocol.self) { _ in
            NetworkService()
        }

        container.register(StoringProtocol.self) { _ in
            StorageService()
        }

        container.register(FetchingProtocol.self) { resolver in
            FetcherService(networkService: resolver.resolve(NetworkingProtocol.self),
                           storageService: resolver.resolve(StoringProtocol.self))
        }

        return container
    }()

    // MARK: - Initializers

    private init() {}

    // MARK: - Public methods

    func configure(with viewController: RecipesViewController) {
        guard let fetchingService = containter.resolve(FetchingProtocol.self) else { return }
        let interactor = RecipesInteractor(fetcherService: fetchingService)
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
