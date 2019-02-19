//
//  TeamListViewController.swift
//  LeagueNavigator
//
//  Created by Dhiman kunal on 19/02/19.
//  Copyright © 2019 Dhiman kunal. All rights reserved.
//

import UIKit

class TeamListViewController: UIViewController {
    
    @IBOutlet private weak var teamsTableView: UITableView! {
        didSet {
            self.configureTableView()
        }
    }
    
    @IBOutlet private weak var searchBar: UISearchBar!
    private var viewModel: TeamListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.fetchTeams { [weak self] state in
            performOnMain {
                self?.render(state)
            }
        }
    }
}

extension TeamListViewController {
    private static let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    static func instance(withLeague league: League, apiClient: APIClient) -> TeamListViewController {
        let identifier = String(describing: self.classForCoder())
        let instance = storyboard.instantiateViewController(withIdentifier: identifier) as! TeamListViewController
        instance.viewModel = TeamListViewModel(league: league, apiClient: apiClient)
        instance.title = league.fullName
        return instance
    }
}

private extension TeamListViewController {
    func configureTableView() {
        self.teamsTableView.register(TeamTableViewCell.nib,
                                     forCellReuseIdentifier: TeamTableViewCell.identifier)
        self.teamsTableView.rowHeight = UITableView.automaticDimension
        self.teamsTableView.dataSource = self
    }
    
    func render(_ state: State) {
        switch state {
        case .loading:
            print("loading")
        case .finished:
            self.teamsTableView.reloadData()
        case .failed(let error):
            print(error)
        }
    }
}

extension TeamListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text else { return }
        self.viewModel.searchTeams(keyword: query, then: { [unowned self] state in
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

extension TeamListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.viewModel.numberOfTeams()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeamTableViewCell.identifier,
                                                 for: indexPath)
        if let teamCell = cell as? TeamTableViewCell,
            let viewModel = self.viewModel.cellViewModelForRowAt(indexPath: indexPath) {
            teamCell.configure(withViewModel: viewModel)
        }
        
        return cell
    }
}
