//
//  FetcherService.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 17.02.2023.
//

import Foundation

final class FetcherService {

    // MARK: - Private properties

    private let networkService: NetworkService
    private let storageService: StorageService

    // MARK: - Initializers

    init(networkService: NetworkService, storageService: StorageService) {
        self.networkService = networkService
        self.storageService = storageService
    }

    // MARK: - Public Methods

    func fetchRecipies(completion: @escaping (Result<RecipeResponse, Error>) -> Void) {
        let parameters = makeParameters()
        networkService.makeRequest(parameters: parameters) { result in
            switch result {
            case .success(let success):
                guard let recipieResponse = try? JSONDecoder().decode(RecipeResponse.self, from: success) else { return }
                completion(.success(recipieResponse))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }

    // MARK: - Private methods

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
        parameters["type"] = "any"
        parameters["imageSize"] = "REGULAR"

        let filters = storageService.loadFilters()

        if filters.dietType != "Any" {
            parameters["diet"] = filters.dietType.lowercased()
        }
        if filters.cuisineType != "Any" {
            parameters["cuisineType"] = filters.cuisineType.lowercased()
        }

        if filters.mealType != "Any" {
            parameters["mealType"] = filters.mealType.lowercased()
        }

        if filters.dishType != "Any" {
            parameters["dishType"] = filters.dishType.lowercased()
        }
        if filters.searchQuery != nil, filters.searchQuery != "" {
            parameters["q"] = filters.searchQuery
        }
        parameters["random"] = String(describing: filters.random)
        return parameters
    }
}
