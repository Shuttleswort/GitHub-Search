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

    fileprivate var _repository = [Repository]()

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

        view?.showHUD()
        interactor.fetchRepository(searchString) { [weak self] response in
            self?.view?.hideHUD()
            self?.handleResponse(response)
        }
    }


    func onScrollPreFetch() {
        view.showHUD()
        interactor.fetchRepositoryOnScroll { [weak self] response in
            self?.view?.hideHUD()
            self?.handleResponse(response)
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

    func cancelSearch() {
        interactor.cancelTasks()
    }


    private func handleResponse(_ response: (Response<RepositoryResult?, APIError>)) {
        switch response {
        case .success(let responseObject):
            guard let repo = responseObject?.items else { return }
            self.interactor.saveToLocalStore(repo)

            self._repository += repo.map {
                Repository(
                    id: $0.id,
                    name: $0.name.count > 30 ? "\($0.name.prefix(30))..." : $0.name,
                    url: $0.url,
                    stars: $0.stars,
                    description: $0.description == nil ? "" : $0.description!.count > 30 ? "\($0.description!.prefix(30))..." : $0.description)
            }

            self._repository.sort(by: { (repo1, repo2) -> Bool in
                return repo1.stars > repo2.stars
            })

            self.view?.reloadTableView()

        case .failure(let error):
            self.view?.showError(error: error)
        }
    }

}

