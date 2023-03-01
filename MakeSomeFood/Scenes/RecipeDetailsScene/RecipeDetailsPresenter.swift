//
//  RecipeDetailsPresenter.swift
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

protocol RecipeDetailsPresentationLogic {
    func presentRecipeDetails(response: RecipeDetails.ShowRecipeDetails.Response)
    func presentFavoriteState(response: RecipeDetails.HandleFavorites.Response)
}

final class RecipeDetailsPresenter: RecipeDetailsPresentationLogic {
    
    // MARK: - Public properties

    weak var viewController: RecipeDetailsDisplayLogic?

    // MARK: - Presentation Logic

    func presentRecipeDetails(response: RecipeDetails.ShowRecipeDetails.Response) {

        typealias ViewModel = RecipeDetails.ShowRecipeDetails.ViewModel

        let recipe = response.recipe

        #warning("not used")
        var cookingTime: String? {
            if recipe.totalTime != 0 {
                let formatString = NSLocalizedString("TIME_LOCALIZATION", comment: "time")
                let localized = String.localizedStringWithFormat(formatString, recipe.totalTime ?? 0)
                return localized
            } else {
                return nil
            }
        }

        let nutritionFactsViewModel = makeNutritionFactsViewModel(from: recipe)

        let ingedientViewModels = makeIngredientsViewModels(from: recipe,
                                                            existingIngredients: response.existingIngredients)

        let viewModel = ViewModel(imageURL: recipe.image ?? "",
                                  recipeURL: recipe.url ?? "",
                                  title: recipe.label ?? "",
                                  totalWeight: String(format: "%.f", recipe.totalWeight ?? 0),
                                  coockingTime: cookingTime,
                                  nutritionFactsViewModel: nutritionFactsViewModel,
                                  ingredientRowiewModels: ingedientViewModels,
                                  isFavorite: recipe.isFavorite ?? false)

        viewController?.displayRecipeDetails(viewModel: viewModel)
    }

    func presentFavoriteState(response: RecipeDetails.HandleFavorites.Response) {
        let viewModel = RecipeDetails.HandleFavorites.ViewModel(state: response.state)
        viewController?.displayFavoriteState(viewModel: viewModel)
    }
}

// MARK: - Extensions

extension RecipeDetailsPresenter {

    private func makeIngredientsViewModels(from recipe: Recipe,
                                           existingIngredients: [Ingredient]) -> [IngredientViewModelProtocol] {

        recipe.ingredients.map { ingredient in
            IngredientRowViewModel(imageURL: ingredient.image ?? "",
                                    name: ingredient.text,
                                    weight: String(format: "%.f", ingredient.weight),
                                    isExisting: existingIngredients.contains(where: { $0.foodId == ingredient.foodId }))
        }
    }

    private func makeNutritionFactsViewModel(from recipe: Recipe) -> NutritionFactsViewRepresentable {
        var caloriesPerServing: String {
            let calories = recipe.calories ?? 0 / (recipe.yield ?? 0)
            return String(format: "%.f", calories) + " kCal"
        }

        return NutritionFactsViewModel(servings: String(format: "%.f", recipe.yield ?? 0),
                                       caloriesPerServing: caloriesPerServing,
                                       nutrients: makeNutrientsViewModels(from: recipe),
                                       vitamins: makeVitaminsViewModels(from: recipe))
    }

    private func makeNutrientsViewModels(from recipe: Recipe) -> [NutrientRowViewRepresentable] {
        var viewModels = recipe.digest
            .filter { $0.total > 0 && $0.unit == "g" && $0.label != "Water" }
            .map { digest in
                let valuePerServing = digest.total / (recipe.yield ?? 0)
                let dailyPercentage = digest.daily / (recipe.yield ?? 0)

                return NutrientRowViewModel(name: digest.label,
                                            value: String(format: "%.f", valuePerServing),
                                            unit: digest.unit,
                                            dailyPercentage: String(format: "%.f", dailyPercentage))
            }

        // DIGEST not including fibers and cholesterol so lets add them

        if let fiber = recipe.totalNutrients?.fibtg {
            let fiberRow = NutrientRowViewModel(name: fiber.label,
                                                value: String(format: "%.f", fiber.quantity / (recipe.yield ?? 0)),
                                                unit: fiber.unit,
                                                dailyPercentage: String(format: "%.f", (recipe.totalDaily?.fibtg?.quantity ?? 0) / (recipe.yield ?? 0)))
            viewModels.append(fiberRow)
        }

        if let cholesterol = recipe.totalNutrients?.chole {
            let fiberRow = NutrientRowViewModel(name: cholesterol.label,
                                                value: String(format: "%.f", cholesterol.quantity / (recipe.yield ?? 0)),
                                                unit: cholesterol.unit,
                                                dailyPercentage: String(format: "%.f", (recipe.totalDaily?.chole?.quantity ?? 0) / (recipe.yield ?? 0)))
            viewModels.append(fiberRow)
        }

        return viewModels
    }

    private func makeVitaminsViewModels(from recipe: Recipe) -> [NutrientRowViewRepresentable] {
        let viewModels = recipe.digest
            .filter { $0.unit != "g" && $0.total > 0 }
            .sorted(by: { $0.daily > $1.daily })
            .prefix(10)
            .map { digest in
                let valuePerServing = digest.total / (recipe.yield ?? 0)
                let dailyPercentage = digest.daily / (recipe.yield ?? 0)

                return NutrientRowViewModel(name: digest.label,
                                            value: String(format: "%.f", valuePerServing),
                                            unit: digest.unit,
                                            dailyPercentage: String(format: "%.f", dailyPercentage))
            }
        return viewModels
    }
}
