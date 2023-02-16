//
//  NetworkService.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 14.02.2023.
//

import Foundation
import Alamofire

final class NetworkService {

    // MARK: - Private properties

    private let storageService: StorageService

    // MARK: - Initializers

    init(storageService: StorageService) {
        self.storageService = storageService
    }

    // MARK: - Public methods

    func fetchRecipies(completion: @escaping (Result<RecipeResponse, AFError>) -> Void) {
        guard let url = createURL(method: API.getRandomRecipies) else { return }
        let parameters = makeParameters()

        AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: RecipeResponse.self) { response in
                switch response.result {
                case .success(let recipies):
                    completion(.success(recipies))
                case .failure(let error):
                    completion(.failure(error))
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

        if let filters = storageService.loadFilters() {
            #warning("optimize later")
            if let diet = filters.dietType {
                parameters["diet"] = diet.lowercased()
            }
            if let cuisine = filters.cuisineType, cuisine != "Any" {
                parameters["cuisineType"] = cuisine
            }

            if let meal = filters.mealType {
                parameters["mealType"] = meal
            }

            if let dish = filters.dishType {
                parameters["dishType"] = dish
            }
            parameters["random"] = String(describing: filters.random)
        }
        return parameters
    }

    private func createURL(method: String) -> URL? {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = method
        return components.url
    }
}
