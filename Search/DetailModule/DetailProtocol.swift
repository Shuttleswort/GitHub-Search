//
//  DetailProtocol.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/25/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import Foundation

//MARK: - DetailConfiguratorProtocol
protocol DetailConfiguratorProtocol: class {
    var url: URL! { get }
    func configure(with viewController: DetailViewController)

}
//MARK: - DetailPresenterProtocol
protocol DetailPresenterProtocol: class {
    var url: URL! { get }
    func onLoad()


}


//MARK: - DetailViewProtocol
protocol DetailViewProtocol: class {

    var presenter: DetailPresenterProtocol!  { get set }
    var configurator: DetailConfiguratorProtocol! { get }

    func loadWebView(_ url: URL)
    func updateUI(_ title: String)


}
