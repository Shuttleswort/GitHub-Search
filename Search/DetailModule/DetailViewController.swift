//
//  DetailViewController.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/25/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, DetailViewProtocol {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var closeButton: UIBarButtonItem!

    var presenter: DetailPresenterProtocol!
    var configurator: DetailConfiguratorProtocol!


    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.onLoad()

    }

    func loadWebView(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    func updateUI(_ title: String) {
        closeButton.title = title
    }


    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
