//
//  SearchRouter.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/23/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import UIKit

class SearchRouter: SearchRouterProtocol {

    weak var viewController: SearchViewController?
    private var url: URL!

    init(viewController: SearchViewController) {
        self.viewController = viewController
    }

    func openRepository(_ url: URL) {
        self.url = url
        viewController?.performSegue(withIdentifier: "repositoryDetail", sender: nil)
    }

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "repositoryDetail" {
            let vc = segue.destination as! DetailViewController
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = viewController
            vc.configurator = DetailConfigurator(url: url)


        }
    }


}
