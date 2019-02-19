//
//  TeamListViewModel.swift
//  LeagueNavigator
//
//  Created by Dhiman kunal on 19/02/19.
//  Copyright © 2019 Dhiman kunal. All rights reserved.
//

import Foundation

final class TeamListViewModel {
    
    private let apiClient: APIClient
    private let league: League
    
    private var teams: [Team]?
    private var searchResults: [Team]?
    
    init(league: League, apiClient: APIClient) {
        self.league = league
        self.apiClient = apiClient
    }
    
    func fetchTeams(then handle: StateObserver?)  {
        self.apiClient.fetchDetails(forLeague: self.league) { [weak self] result in
            switch result {
            case .success(let leagues):
                self?.teams = leagues.sorted(by: { $0.fullName < $1.fullName })
                performOnMain { handle?(.finished) }
            case .failed(let error):
                performOnMain { handle?(.failed(error)) }
            }
        }
    }
    
    func searchTeams(keyword: String, then handle: StateObserver?) {
        guard !keyword.isEmpty else {
            self.cancelSearch(then: handle)
            return
        }
        self.searchResults = self.teams?.filter {
            $0.name.localizedCaseInsensitiveContains(keyword)
                || $0.location.localizedCaseInsensitiveContains(keyword)
                || $0.fullName.localizedCaseInsensitiveContains(keyword)
        }
        handle?(.finished)
    }
    
    func cancelSearch(then handle: StateObserver?) {
        self.searchResults = nil
        handle?(.finished)
    }
    
    func numberOfTeams() -> Int {
        if let searchResults = self.searchResults {
            return searchResults.count
        }
        
        return self.teams?.count ?? 0
    }
    
    func cellViewModelForRowAt(indexPath: IndexPath) -> TeamCellViewModel? {
        var teams = self.searchResults ?? self.teams
        
        guard let team = teams?[indexPath.row] else { return nil }
        
        return TeamCellViewModel(team: team, session: URLSession.shared)
    }
}
