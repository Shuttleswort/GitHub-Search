//
//  SearchPresenter.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/23/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import Foundation

class SearchPresenter: SearchPresenterProtocol {

    weak private var view: SearchViewProtocol!
    var interactor: SearchInteractorProtocol!
    var router: SearchRouterProtocol!

    var navTitle = NSLocalizedString("searchSceneTitle", comment: "")
    var searchBarPlaceholder = NSLocalizedString("searchBarPlaceholder", comment: "")

    fileprivate (set) var _repository = [Repository]()
    var repository: [Repository] {
        return _repository
    }

    private var page = 1
    private var queryString = ""


    required init(view: SearchViewProtocol) {
        self.view = view
    }


    func startSearch(_ query: String?) {
        _repository = [Repository]()
        view?.reloadTableView()

        guard let searchString = query, searchString.count > 0  else {
            self.view?.showError(error: .noQueryString)
            return
        }

        if Reachability.isConnectedToNetwork() {
            page = 1
            queryString = searchString
            _repository = [Repository]()
            view?.reloadTableView()

            for i in self.page...2 {
                let parameters: [String: Any] = ["q": queryString, "page": i]
                fetchRepo(parameters)
                page += 1
            }

        } else {
            self.view.showHUD()
            interactor.fetchRepositoryFromLocal(searchString) { [weak self] (repositoryArray, error) in
                self?.view.hideHUD()
                guard let repoArray = repositoryArray, error == nil else {
                    self?.view?.showError(error: error!)
                    return
                }
                self?.prepareData(repoArray)
                self?.view?.reloadTableView()
            }
        }
    }


    func onScrollPreFetch() {
        if Reachability.isConnectedToNetwork() {
            for i in stride(from: page, to: page + 2, by: 1) {
                let parameters: [String: Any] = ["q": queryString, "page": i]
                fetchRepo(parameters)
                page += 1
            }
        }
    }

    func didTapRow(_ index: IndexPath) {
        if !Reachability.isConnectedToNetwork() {
            self.view.showError(error: .noInternetConnection)
            return
        }

        let urlString = self._repository[index.row].url
        guard let url = URL(string: urlString) else { return }
        router.openRepository(url)
    }



    private func prepareData(_ repositoryArray: [Repository]) {
        self._repository += repositoryArray.map {
            Repository(
                id: $0.id,
                name: $0.name.count > 30 ? "\($0.name.prefix(30))..." : $0.name,
                url: $0.url,
                stars: $0.stars,
                description: $0.description == nil ? "" : $0.description!.count > 30 ? "\($0.description!.prefix(30))..." : $0.description)
        }
    }


    private func fetchRepo(_ parameters: [String: Any]) {
        view?.showHUD()
        self.interactor.fetchRepository(parameters) { [weak self] response in
            self?.view?.hideHUD()
            switch response {
            case .success(let responseObject):
                guard let repo = responseObject?.items else { return }
                self?.interactor.saveToLocalStore(repo)
                self?.prepareData(repo)

                self?._repository.sort(by: { (repo1, repo2) -> Bool in
                    return repo1.stars > repo2.stars
                })

                self?.view?.reloadTableView()

            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }


    func cancelSearch() {
        interactor.cancelTasks()
    }

}












