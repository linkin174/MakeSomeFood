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

    func fetchRandomRecipies(quantity: Int = 10, completion: @escaping (Result<[Recipe], AFError>) -> Void) {
        guard let url = createURL(method: API.getRandomRecipies) else { return }
        var parameters = makeParameters()
        parameters["number"] = String(quantity)
        AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: [Recipe].self) { response in
                switch response.result {
                case .success(let recipies):
                    completion(.success(recipies))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    // MARK: - Private methods

    private func createURL(method: String) -> URL? {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = method
        return components.url
    }

    private func makeParameters() -> [String: String] {
        var parameters = [String: String]()
        guard let key = Bundle.main.infoDictionary?["API_KEY"] as? String else { return parameters }
        print("PASS GUARD")
        print("KEY \(key)")
        parameters["apiKey"] = key
        return parameters
    }

}
