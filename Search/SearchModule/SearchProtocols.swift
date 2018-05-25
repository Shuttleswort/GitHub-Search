//
//  SearchProtocols.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/23/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import UIKit

//MARK: - SearchConfiguratorProtocol
protocol SearchConfiguratorProtocol: class {
    func configure(with viewController: SearchViewController)

}
//MARK: - SearchPresenterProtocol
protocol SearchPresenterProtocol: class {

    var interactor: SearchInteractorProtocol! { get set }
    var router: SearchRouterProtocol! { get set }
    var searchBarPlaceholder: String { get }
    var navTitle: String { get }
    var repository: [Repository] { get }

    func startSearch(_ query: String?)
    func cancelSearch()
    func onScrollPreFetch()
    func didTapRow(_ index: IndexPath)

}


//MARK: - SearchInteractorInputProtocol
protocol SearchInteractorProtocol: class {

    var presenter: SearchPresenterProtocol!  { get set }

    func fetchRepository(_ parameters: [String : Any], completion: @escaping (Response<RepositoryResult?, APIError>) -> ())
    func fetchRepositoryFromLocal(_ query: String, completion: @escaping ([Repository]?, APIError?) -> ())
    func saveToLocalStore(_ repository: [Repository])
    func cancelTasks()


}

//MARK: - SearchViewProtocol
protocol SearchViewProtocol: class {

    var presenter: SearchPresenterProtocol!  { get set }

    func showHUD()
    func hideHUD()
    func showError(error: APIError)
    func reloadTableView()

}

protocol SearchRouterProtocol: class {
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func openRepository(_ url: URL)
}
