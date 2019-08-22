//
//  APIService.swift
//  Smart Scanner
//
//  Created by Bilguun Batbold on 15/8/19.
//  Copyright © 2019 ISEM. All rights reserved.
//

import Foundation

class APIService {
    
    public static let shared = APIService()
    
    init() {}
    
    private let urlSession = URLSession.shared
    private let baseURL = "http://127.0.0.1:3000/api"
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    enum EndPoint: String, CaseIterable {
        case userRegister = "users/register"
        case userLogin = "users/login"
        case userAddCard = "users/addCard"
    }
    
    
    public enum APIServiceError: Error {
        case apiError
        case invalidEndpoint
        case invalidResponse
        case noData
        case decodeError
    }
    
    private func fetchResources<T: Decodable>(url: URL, completion: @escaping (Result<T, APIServiceError>) -> ()) {
        
        urlSession.dataTask(with: url) { (result) in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(_):
                completion(.failure(.apiError))
            }
        }.resume()
    }
}
