//
//  ApiRequest.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/23/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import Foundation

protocol BaseRequestProtocol {
    var baseString: String { get }
    var path: String { get }
    var httpMethod: String { get }
    var parameters: [String: Any] { get }
}

extension BaseRequestProtocol {

    var urlComponents: URLComponents {
        var urlComponents = URLComponents(string: baseString)!
        urlComponents.path = path
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0, value: "\($1)") }
        return urlComponents
    }

    var request: URLRequest {
        let url = urlComponents.url!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        return urlRequest
    }

}
