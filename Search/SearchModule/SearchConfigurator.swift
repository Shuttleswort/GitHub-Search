//
//  SearchConfigurator.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/23/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import Foundation

class SearchConfigurator: SearchConfiguratorProtocol {
    
    func configure(with viewController: SearchViewController) {
        let presenter = SearchPresenter(view: viewController)
        let interactor = SearchInteractor(presenter: presenter)
        let router = SearchRouter(viewController: viewController)

        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router

    }

}
