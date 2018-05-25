//
//  DetailPresenter.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/25/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import Foundation

class DetailPresenter: DetailPresenterProtocol {

    weak private var view: DetailViewProtocol!

    var url: URL!
    let closeBtnTitle = NSLocalizedString("detailCloseBtn", comment: "")


    required init(view: DetailViewProtocol) {
        self.view = view
    }

    func onLoad() {
        view.updateUI(closeBtnTitle)
        view.loadWebView(url)
    }


    
}
