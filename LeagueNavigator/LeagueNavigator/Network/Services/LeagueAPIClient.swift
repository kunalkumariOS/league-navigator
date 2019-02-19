//
//  LeagueAPIClient.swift
//  LeagueNavigator
//
//  Created by Dhiman kunal on 18/02/19.
//  Copyright © 2019 Dhiman kunal. All rights reserved.
//

import Foundation

final class LeagueAPIClient: APIClient {
    var baseURL: URL
    var session: NetworkSession
    
    init(baseURL: URL = NetworkConstants.baseURL,
         session: NetworkSession = URLSession(configuration: .ephemeral)) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func fetchLeagues(then handle: @escaping (Result<[League]>) -> Void) {
        let serviceRequest = LeagueService(baseURL: self.baseURL)
        serviceRequest.execute(onSession: self.session, then: handle)
    }
    
    func fetchDetails(forLeague league: League, then handle: @escaping (Result<[Team]>) -> Void) {
        let serviceRequest = LeaguesDetailsService(baseURL: self.baseURL, parameter: league.slug)
        serviceRequest.execute(onSession: self.session, then: handle)
    }
}
