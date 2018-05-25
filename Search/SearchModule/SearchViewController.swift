//
//  SearchViewController.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/23/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import UIKit

private let repoCellIdentifier = "repoCell"

class SearchViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

	var presenter: SearchPresenterProtocol!
    let configurator = SearchConfigurator()

	override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)

        title = presenter.navTitle
        searchBar.placeholder = presenter.searchBarPlaceholder

        tableView.tableFooterView = UIView()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }


    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalUpAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalDownAnimator()
    }


    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ModalPresentationController(presentedViewController: presented, presenting: source)

    }

}

extension SearchViewController: SearchViewProtocol {

    func reloadTableView() {
        tableView.reloadData()
    }

    func showError(error: APIError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }


    func showHUD() {
        self.activityIndicator.isHidden = false
    }

    func hideHUD() {
        self.activityIndicator.isHidden = true
    }


}

extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.repository.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: repoCellIdentifier, for: indexPath) as? RepoCell else {
            fatalError("Catn't create RepoCell")
        }

        let repo = self.presenter.repository[indexPath.row]
        cell.configure(with: repo)

        return cell
    }
}

extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didTapRow(indexPath)
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
    }


    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.cancelSearch()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.startSearch(searchBar.text)
    }
}


extension SearchViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - currentOffset <= 300 {
            presenter.onScrollPreFetch()
        }
    }
}




