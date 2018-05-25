//
//  SearchInteractor.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/23/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import Foundation

class SearchInteractor: SearchInteractorProtocol {

    weak var presenter: SearchPresenterProtocol!

    let searchService: SearchServiceProtocol = SearchService()
    let localSearchServie = SearchCoreDataStack(containerIdentifier: "Search")

    private let queue = DispatchQueue(label: "search.queue", qos: .userInteractive , attributes: .concurrent)
    private var blocks = [DispatchWorkItem]()
    private var dataTasks = [URLSessionDataTask]()

    required init(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
    }


    func cancelTasks() {
        dataTasks.forEach { $0.cancel() }
        blocks.forEach { $0.cancel() }
        blocks = [DispatchWorkItem]()
        dataTasks = [URLSessionDataTask]()
    }


    func fetchRepository(_ parameters: [String : Any], completion: @escaping (Response<RepositoryResult?, APIError>) -> ()) {
        let block = DispatchWorkItem(flags: .inheritQoS) { [unowned self] in
            self.dataTasks.append(
                self.searchService.searchRepo(with: parameters) { response in
                    completion(response)
                }
            )
        }
        blocks.append(block)
        queue.async(execute: block)
    }

    func fetchRepositoryFromLocal(_ query: String, completion: @escaping ([Repository]?, APIError?) -> ()) {
        localSearchServie.fetchRepository(with: query) { (response, error) in
            guard let moArray = response else {
                completion(nil, .coreDataError)
                return
            }

            let repositoryArray = moArray.map { $0.toRepository() }
            completion(repositoryArray, nil)
        }

    }


    func saveToLocalStore(_ repository: [Repository]) {
        localSearchServie.createManagedRepository(repository)
    }





}
