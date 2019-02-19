//
//  LeagueService.swift
//  LeagueNavigator
//
//  Created by Dhiman kunal on 18/02/19.
//  Copyright © 2019 Dhiman kunal. All rights reserved.
//

import Foundation

struct LeagueService: ServiceRequest {
    private static let path = "leagues.json"
    typealias ResponseType = [League]
    
    let baseURL: URL
    func asURLRequest() throws -> URLRequest {
        
        return try self.baseURL.appendingPathComponent(type(of: self).path).asURLRequest()
    }
}
