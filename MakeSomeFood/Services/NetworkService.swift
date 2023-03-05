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

    /// Alamofire network request with given parameters.
    /// - Parameters:
    ///   - parameters: Dictionary containing parameters for request
    ///   - completion: ``Result`` type containing ``Data`` or Alamofire ``AFError``
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

    /// Alamofire network request with given URL and no parameters
    /// - Parameters:
    ///   - url: ``URL`` address
    ///   - completion: ``Result`` type containing ``Data`` or Alamofire ``AFError``
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

    /// Creates URL for given API method
    /// - Parameter method: Method described in ``API`` (``String``)
    /// - Returns: optional ``URL``
    private func createURL(method: String) -> URL? {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = method
        return components.url
    }
}
