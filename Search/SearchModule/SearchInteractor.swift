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
    private let lockQueue = DispatchQueue(label: "lock.queue")

    private var page = 1
    private var queryString = ""

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

    func fetchRepository(_ query: String, completion: @escaping (Response<RepositoryResult?, APIError>) -> ()) {
        page = 1
        queryString = query

        if Reachability.isConnectedToNetwork() {
            for i in self.page...2 {
                fetchRepository(["q": queryString, "page": i]) { reposponse in
                    completion(reposponse)
                }
                page += 1
            }

        } else {
            fetchRepositoryFromLocal(queryString) { (response, error) in
                guard let repoArray = response, error == nil else {
                    completion(.failure(.coreDataError))
                    return
                }
                completion(.success(RepositoryResult(items: repoArray)))
            }


        }
    }

    func fetchRepositoryOnScroll(completion: @escaping (Response<RepositoryResult?, APIError>) -> ()) {
        if Reachability.isConnectedToNetwork() {
            for i in stride(from: page, to: page + 2, by: 1) {
                let parameters: [String: Any] = ["q": queryString, "page": i]
                fetchRepository(parameters) { reposponse in
                    completion(reposponse)
                }
                page += 1
            }
        } else {
            completion(.failure(.noInternetConnection))
        }
    }


    private func fetchRepository(_ parameters: [String : Any], completion: @escaping (Response<RepositoryResult?, APIError>) -> ()) {
        let block = DispatchWorkItem(flags: .inheritQoS) { [unowned self] in

            print(Thread.current)

            let task = self.searchService.searchRepo(with: parameters) { response in
                print("r com - \(Thread.current)")
                completion(response)
            }

            DispatchQueue(label: "private.queue").async {
                self.dataTasks.append(task)
                print("sync - \(Thread.current)")
            }
        }
        blocks.append(block)
        queue.async(execute: block)
    }

    private func fetchRepositoryFromLocal(_ query: String, completion: @escaping ([Repository]?, APIError?) -> ()) {
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
