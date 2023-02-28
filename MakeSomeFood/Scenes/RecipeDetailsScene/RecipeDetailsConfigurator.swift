//
//  RecipeDetailsConfigurator.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 28.02.2023.
//

import Foundation
import Swinject

final class RecipesDetailsConfigurator {

    // MARK: - Static properties

    static let shared = RecipesDetailsConfigurator()

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

    func configure(with viewController: RecipeDetailsViewController) {
        guard let storageService = containter.resolve(StorageService.self) else { return }
        let interactor = RecipeDetailsInteractor(storageService: storageService)
        let presenter = RecipeDetailsPresenter()
        let router = RecipeDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
