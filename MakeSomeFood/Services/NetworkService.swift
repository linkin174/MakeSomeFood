//
//  NetworkService.swift
//  MakeSomeFood
//
//  Created by Aleksandr Kretov on 14.02.2023.
//

import Alamofire
import Foundation

protocol NetworkingProtocol: AnyObject {
    func makeRequest(parameters: [String: String]?, completion: @escaping (Result<Data, AFError>) -> Void)
    func makeRequest(from url: URL, completion: @escaping (Result<Data, AFError>) -> Void)
}

final class NetworkService: NetworkingProtocol {

    // MARK: - Public methods

    func makeRequest(parameters: [String: String]?, completion: @escaping (Result<Data, AFError>) -> Void) {
        guard let url = createURL(method: API.getRandomRecipies) else { return }
        AF.request(url, parameters: parameters)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let recipies):
                    completion(.success(recipies))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    func makeRequest(from url: URL, completion: @escaping (Result<Data, AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
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
}
