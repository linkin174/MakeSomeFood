//
//  RecipesInteractor.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 14.02.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import Foundation

protocol RecipesBuisnessLogic {
    func viewDidLoad()
    func loadNextRecipes()
}

protocol RecipesDataStore {
    var recipes: [Recipe] { get }
}

class RecipesInteractor: RecipesBuisnessLogic, RecipesDataStore {

    // MARK: - Public properties

    var presenter: RecipesPresentationLogic?

    // MARK: - Public properties

    var recipes: [Recipe] = []

    // MARK: - Private properties

    private var recipieResponse: RecipeResponse?
    private var fetcherService: FetchingProtocol

    // MARK: - Initializers

    init(fetcherService: FetchingProtocol) {
        self.fetcherService = fetcherService
    }

    // MARK: Interaction Logic

    func viewDidLoad() {
        fetcherService.fetchRecipies { [unowned self] result in
            switch result {
            case .success(let recipeResponse):
                self.recipieResponse = recipeResponse
                recipes = recipeResponse.hits.compactMap { $0.recipe }
                let response = RecipesList.DisplayRecipes.Response(recipes: recipes)
                presenter?.presentRecipes(response: response)
            case .failure(let failure):
                let response = RecipesList.HandleError.Response(error: failure)
                presenter?.presentError(response: response)
            }
        }
    }

    func loadNextRecipes() {
        guard let endPoint = recipieResponse?.links?.next?.href else { return }
        fetcherService.fetchNextRecipes(from: endPoint) { [unowned self] result in
            switch result {
            case .success(let recipeResponse):
                DispatchQueue.main.async {
                    let newRecipes = recipeResponse.hits.compactMap { $0.recipe }
                    self.recipes.append(contentsOf: newRecipes)
                    self.recipieResponse = recipeResponse
                    let response = RecipesList.DisplayRecipes.Response(recipes: self.recipes)
                    self.presenter?.presentRecipes(response: response)
                }
            case .failure(let error):
                let response = RecipesList.HandleError.Response(error: error)
                presenter?.presentError(response: response)
            }
        }
    }
}
