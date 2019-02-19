//
//  APIClient.swift
//  LeagueNavigator
//
//  Created by Dhiman kunal on 18/02/19.
//  Copyright © 2019 Dhiman kunal. All rights reserved.
//

import Foundation

protocol APIClient {
    
    var baseURL: URL { get }
    var session: NetworkSession { get }
    
    init(baseURL: URL, session: NetworkSession)
    
    func fetchLeagues(then handle:  @escaping (Result<[League]>) -> Void)
    func fetchDetails(forLeague league: League, then handle:  @escaping (Result<[Team]>) -> Void)
}
