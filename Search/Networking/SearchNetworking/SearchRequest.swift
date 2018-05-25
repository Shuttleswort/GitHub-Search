//
//  SearchRequest.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/23/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import Foundation

private let baseURLString = "https://api.github.com"
private let searchRepoPath = "/search/repositories"

enum SearchRequest {
    case searchRepository(parameters: [String: Any])
}

extension SearchRequest: BaseRequestProtocol {

    var baseString: String {
        return baseURLString
    }

    var path: String {
        switch self {
        case .searchRepository: return searchRepoPath
        }
    }

    var parameters: [String: Any] {
        switch self {
        case var .searchRepository(parameters):
            parameters["sort"] = "stars"
            parameters["per_page"] = 15
            return parameters
        }
    }

    var httpMethod: String {
        switch self {
        case .searchRepository: return "GET"
        }
    }
}
