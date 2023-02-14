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
        var parameters = [String: String]()
        guard let appId = Bundle.main.infoDictionary?["APP_KEY"] as? String else { return }
        guard let key = Bundle.main.infoDictionary?["API_KEY"] as? String else { return }
        parameters["app_id"] = appId
        parameters["app_key"] = key
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

    func fetchImageData(from url: URL) async -> Data? {
        let result = try? await URLSession.shared.data(for: URLRequest(url: url))
        return result?.0
    }

    func fetchImageData(from url: URL, completion: @escaping (Result<Data, AFError>) -> Void) {
        AF.request(url)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data else { return }
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    // MARK: - Private methods

    private func createURL(method: String, parameters: [String: String]? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = method
        if let parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        }
        return components.url
    }
//
//    private func makeParameters() -> [String: String] {
//        var parameters = [String: String]()
//        guard let key = Bundle.main.infoDictionary?["API_KEY"] as? String else { return parameters }
//        parameters["apiKey"] = key
//        return parameters
//    }

}
