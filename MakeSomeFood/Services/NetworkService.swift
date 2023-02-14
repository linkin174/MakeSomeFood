//
//  NetworkService.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 14.02.2023.
//

import Foundation
import Alamofire

final class NetworkService {
    // MARK: - Public methods

    func fetchRandomRecipies(completion: @escaping (Result<RecipeResponse, AFError>) -> Void) {
        guard let url = createURL(method: API.getRandomRecipies) else { return }
        var parameters = makeParameters()
        parameters["random"] = "true"
        parameters["type"] = "any"
        parameters["imageSize"] = "REGULAR"

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
