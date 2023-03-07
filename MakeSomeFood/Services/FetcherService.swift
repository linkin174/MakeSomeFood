//
//  FetcherService.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 17.02.2023.
//

import Foundation

protocol FetchingProtocol: AnyObject {
    func fetchRecipies(completion: @escaping (Result<RecipeResponse, Error>) -> Void)
    func fetchNextRecipes(from urlString: String, completion: @escaping (Result<RecipeResponse, Error>) -> Void)
    init(networkService: NetworkingProtocol?, storageService: StoringProtocol?)
}

final class FetcherService: FetchingProtocol {

    // MARK: - Private properties

    private let networkService: NetworkingProtocol?
    private let storageService: StoringProtocol?

    // MARK: - Initializers

    init(networkService: NetworkingProtocol?, storageService: StoringProtocol?) {
        self.networkService = networkService
        self.storageService = storageService
    }

    // MARK: - Public Methods

    /// Fetches 20 recipes for given filters
    /// - Parameter completion: ``Result`` type completion containing ``RecipeResponse`` object or ``Error``
    func fetchRecipies(completion: @escaping (Result<RecipeResponse, Error>) -> Void) {
        let parameters = makeParameters()
        networkService?.makeRequest(parameters: parameters) { result in
            switch result {
            case .success(let success):
                do {
                    let recipeResponse = try JSONDecoder().decode(RecipeResponse.self, from: success)
                    completion(.success(recipeResponse))
                } catch  {
                    completion(.failure(error))
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }

    /// Fetches next page of 20 recipes
    /// - Parameters:
    ///   - urlString: URL adress of next page as ``String``
    ///   - completion: ``Result`` type completion containing ``RecipeResponse`` object or ``Error``
    func fetchNextRecipes(from urlString: String, completion: @escaping (Result<RecipeResponse, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        networkService?.makeRequest(from: url) { result in
            switch result {
            case .success(let data):
                do {
                    let recipeResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
                    completion(.success(recipeResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Private methods

    /// Makes dictionary of parameters for request.
    /// Loads current filters from ``StorageService``
    /// - Returns: Dictionary containing all the paraneters for request such as API key and filters
    private func makeParameters() -> [String: String] {
        var parameters = [String: String]()
        guard
            let appId = Bundle.main.infoDictionary?["APP_KEY"] as? String,
            let key = Bundle.main.infoDictionary?["API_KEY"] as? String
        else {
            return [:]
        }
        parameters["app_id"] = appId
        parameters["app_key"] = key
        parameters["type"] = "public"
        parameters["imageSize"] = "REGULAR"

        guard let filters = storageService?.loadFilters() else { return parameters }

        if filters.dietType != "Any" {
            parameters["diet"] = filters.dietType.lowercased()
        }
        if filters.cuisineType != "Any" {
            parameters["cuisineType"] = filters.cuisineType
        }

        if filters.mealType != "Any" {
            parameters["mealType"] = filters.mealType
        }

        if filters.dishType != "Any" {
            parameters["dishType"] = filters.dishType
        }
        if filters.searchQuery != nil, filters.searchQuery != "" {
            parameters["q"] = filters.searchQuery
        }
        parameters["random"] = String(describing: filters.random)
        return parameters
    }
}
