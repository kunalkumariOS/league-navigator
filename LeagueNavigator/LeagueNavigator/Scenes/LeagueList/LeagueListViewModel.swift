//
//  LeagueListViewModel.swift
//  LeagueNavigator
//
//  Created by Dhiman kunal on 18/02/19.
//  Copyright © 2019 Dhiman kunal. All rights reserved.
//

import UIKit

final class LeagueListViewModel {

    let apiClient: APIClient
    
    private var leagues: [League]?
    private var searchResults: [League]?
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchLeagues(then handle: StateObserver?) {
        self.apiClient.fetchLeagues {[weak self] result in
            switch result {
            case .success(let leagues):
                self?.leagues = leagues.sorted(by: { $0.fullName < $1.fullName })
                performOnMain { handle?(.finished) }
            case .failed(let error):
                performOnMain { handle?(.failed(error)) }
            }
        }
    }
    
    func searchLeagues(keyword: String, then handle: StateObserver?) {
        guard !keyword.isEmpty else {
            self.cancelSearch(then: handle)
            return
        }
        self.searchResults = self.leagues?.filter({ $0.fullName.localizedCaseInsensitiveContains(keyword) || $0.slug.localizedCaseInsensitiveContains(keyword) })
        handle?(.finished)
    }
    
    func cancelSearch(then handle: StateObserver?) {
        self.searchResults = nil
        handle?(.finished)
    }
    
    func numberOfLeagues() -> Int {
        if let searchResults = self.searchResults {
            return searchResults.count
        }
        
        return self.leagues?.count ?? 0
    }
    
    func cellViewModelForRowAt(indexPath: IndexPath) -> LeagueCellViewModelType? {
        var leagues = self.searchResults ?? self.leagues
        
        guard let league = leagues?[indexPath.row] else { return nil }
        
        return LeagueCellViewModel(league: league)
    }
    
    func teamListViewControllerForRowAt(indexPath: IndexPath) -> UIViewController? {
        var leagues = self.searchResults ?? self.leagues
        
        guard let league = leagues?[indexPath.row] else { return nil }
        
        return TeamListViewController.instance(withLeague: league, apiClient: self.apiClient)
    }
}

