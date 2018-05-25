//
//  DetaailConfigurator.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/25/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import Foundation

class DetailConfigurator: DetailConfiguratorProtocol {

    var url: URL!

    required init(url: URL) {
        self.url = url
    }

    func configure(with viewController: DetailViewController) {
        let presenter = DetailPresenter(view: viewController)
        presenter.url = url
        viewController.presenter = presenter
    }


}
