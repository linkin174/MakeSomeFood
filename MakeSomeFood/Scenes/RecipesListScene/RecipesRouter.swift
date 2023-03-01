//
//  RecipesRouter.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 14.02.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol RecipesRoutingLogic {
    func routeToRecipeDetails()
    func presentFilters()
}

protocol RecipesDataPassing {
    var dataStore: RecipesDataStore? { get }
}

final class RecipesRouter: RecipesRoutingLogic, RecipesDataPassing {

    weak var viewController: RecipesViewController?
    var dataStore: RecipesDataStore?

    func routeToRecipeDetails() {

        let destination = RecipeDetailsViewController()

        guard
            let source = viewController,
            var destinationDS = destination.router?.dataStore,
            let dataStore
        else {
            return
        }
        passDataToRecipeDetails(source: dataStore, destination: &destinationDS)
        navigateToRecipeDetails(source: source, destination: destination)
    }

    func presentFilters() {
        let vcToPresent = FiltersViewController(storageService: StorageService())
        vcToPresent.delegate = viewController
        viewController?.present(vcToPresent, animated: true)
    }


// MARK: Passing data to other screen

    func passDataToRecipeDetails(source: RecipesDataStore, destination: inout RecipeDetailsDataStore) {
        guard let viewController else { return }
        guard let indexPath = viewController.collectionView.indexPathsForSelectedItems?.first else { return }
        let recipe = source.recipes[indexPath.item]
        destination.recipe = recipe
    }

    func navigateToRecipeDetails(source: UIViewController, destination: UIViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
}
