//
//  FavoritesPresenter.swift
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

protocol FavoritesPresentationLogic {
    func presentFavorites(response: FavoritesList.ShowFavorites.Response)
}

class FavoritesPresenter: FavoritesPresentationLogic {
    weak var viewController: FavoritesDisplayLogic?

    // MARK: Parse and calc respnse from FavoritesInteractor and send simple view model to FavoritesViewController to be displayed

    func presentFavorites(response: FavoritesList.ShowFavorites.Response) {
        let cells = response.recipes.map { recipe in
            let thumbnailImageUrl = URL(string: recipe.images?.small?.url ?? "")
            return RecipeCellViewModel(dishName: recipe.label ?? "", imageURL: thumbnailImageUrl)
        }
        let viewModel = FavoritesList.ShowFavorites.ViewModel(cells: cells)
        viewController?.displayFavoriteRecipes(viewModel: viewModel)
    }
}
