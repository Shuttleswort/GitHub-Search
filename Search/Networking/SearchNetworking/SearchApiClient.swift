//
//  SearchApiClient.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/23/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import Foundation

protocol SearchApiClientProtocol: class {
    func getRepositiry(with parameters: [String: Any], completion: @escaping (Response<RepositoryResult?, APIError>) -> ()) -> URLSessionDataTask
}

class SearchApiClient: BaseApiClientProtocol, SearchApiClientProtocol {

    let session: URLSession

    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }

    convenience init() {
        self.init(configuration: .default)
    }


    func getRepositiry(with parameters: [String: Any], completion: @escaping (Response<RepositoryResult?, APIError>) -> ()) -> URLSessionDataTask {
        let request = SearchRequest.searchRepository(parameters: parameters).request
        
        return perform(request, decode: { object -> RepositoryResult? in
            guard let repositoryList = object as? RepositoryResult else { return  nil }
            return repositoryList
        }, completion: completion)
    }
}
