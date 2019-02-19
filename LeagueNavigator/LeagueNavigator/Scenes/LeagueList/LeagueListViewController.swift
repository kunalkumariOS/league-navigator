//
//  LeagueListViewController.swift
//  LeagueNavigator
//
//  Created by Dhiman kunal on 18/02/19.
//  Copyright © 2019 Dhiman kunal. All rights reserved.
//

import UIKit

final class LeagueListViewController: UIViewController {
    
    var viewModel: LeagueListViewModel = LeagueListViewModel(apiClient: LeagueAPIClient())
    
    @IBOutlet private weak var leaguesTableView: UITableView! {
        didSet {
            self.configureTableView()
        }
    }
    
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            self.searchBar.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.fetchLeagues { [unowned self] state in
            self.render(state)
        }
    }
}

private extension LeagueListViewController {
    
    static let leaguesTableViewCellIdentifier = "leaguesTableViewCellIdentifier"
    
    func configureTableView() {
        self.leaguesTableView.register(UITableViewCell.self,
                                       forCellReuseIdentifier: type(of: self).leaguesTableViewCellIdentifier)
        self.leaguesTableView.rowHeight = UITableView.automaticDimension
        self.leaguesTableView.dataSource = self
        self.leaguesTableView.delegate = self
    }
    
    func render(_ state: State) {
        switch state {
        case .loading:
            print("loading")
        case .finished:
            self.leaguesTableView.reloadData()
        case .failed(let error):
            print(error)
        }
    }
}

extension LeagueListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text else { return }
        self.viewModel.searchLeagues(keyword: query, then: { [unowned self] state in
            self.render(state)
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.viewModel.cancelSearch(then: { [unowned self] state in
            self.render(state)
        })
    }
}

extension LeagueListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfLeagues()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).leaguesTableViewCellIdentifier,
                                                 for: indexPath)
        if let cellViewModel = self.viewModel.cellViewModelForRowAt(indexPath: indexPath) {
            cell.textLabel?.attributedText = cellViewModel.fullName
        }
        return cell
    }
}

extension LeagueListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let destinationViewController = self.viewModel.teamListViewControllerForRowAt(indexPath: indexPath) else { return }
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
}
