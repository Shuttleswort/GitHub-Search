//
//  SearchService.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/23/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import Foundation

protocol SearchServiceProtocol: class {
    func searchRepo(with parameters: [String: Any], completion: @escaping (Response<RepositoryResult?, APIError>) -> ()) -> URLSessionDataTask
}

class SearchService: SearchServiceProtocol {

    let searchApiClient: SearchApiClientProtocol = SearchApiClient()


    func searchRepo(with parameters: [String : Any], completion: @escaping (Response<RepositoryResult?, APIError>) -> ()) -> URLSessionDataTask {
        return searchApiClient.getRepositiry(with: parameters) { response in
            completion(response)
        }
    }


    


}





















