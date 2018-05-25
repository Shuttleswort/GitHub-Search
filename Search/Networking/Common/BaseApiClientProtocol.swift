//
//  BaseApiClient.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/23/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import Foundation

enum Response<T, E> where E: Error  {
    case success(T)
    case failure(E)
}

enum APIError: Error {
    case requestFailed
    case requestCanceled
    case jsonConversionFailed
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailed
    case apiRateLimit
    case coreDataError
    case noQueryString
    case noInternetConnection


    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .requestCanceled: return "Data task canceled"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailed: return "JSON Parsing Failed"
        case .jsonConversionFailed: return "JSON Conversion Failed"
        case .apiRateLimit: return "API rate limit"
        case .coreDataError: return "CoreData error"
        case .noQueryString: return "No query string"
        case .noInternetConnection: return "No internet connection"
        }
    }
}

protocol BaseApiClientProtocol {
    var session: URLSession { get }
    func perform<T: Decodable>(_ request: URLRequest, decode: @escaping (Decodable) -> T?,
                               completion: @escaping (Response<T, APIError>) -> ()) -> URLSessionDataTask
}

extension BaseApiClientProtocol {
    typealias DecodableCompletionHandler = (Decodable?, APIError?) -> Void

    func perform<T: Decodable>(_ request: URLRequest, decode: @escaping (Decodable) -> T?,
                               completion: @escaping (Response<T, APIError>) -> ()) -> URLSessionDataTask {

        let task = decodingTask(with: request, decodingType: T.self) { (object , error) in
            DispatchQueue.main.async {
                guard let object = object else {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.failure(.invalidData))
                    }
                    return
                }
                if let value = decode(object) {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonParsingFailed))
                }
            }
        }
        task.resume()
        return task
    }

    func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type,
                                    completionHandler completion: @escaping DecodableCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                if let error = error, error.localizedDescription == "cancelled" {
                    completion(nil, .requestCanceled)
                } else {
                    completion(nil, .requestFailed)
                }
                return
            }

            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let genericModel = try JSONDecoder().decode(decodingType, from: data)
                        completion(genericModel, nil)
                    } catch {
                        completion(nil, .jsonConversionFailed)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else if httpResponse.statusCode == 403 {
                completion(nil, .apiRateLimit)
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
}
