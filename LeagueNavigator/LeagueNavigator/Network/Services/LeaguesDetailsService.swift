//
//  LeaguesDetailsService.swift
//  LeagueNavigator
//
//  Created by Dhiman kunal on 18/02/19.
//  Copyright © 2019 Dhiman kunal. All rights reserved.
//

import Foundation

struct LeaguesDetailsService: ParameterdRequest {
    private static let path = "leagues/"
    private static let pathExtension = ".json"
    typealias ParameterType = String
    
    typealias ResponseType = [Team]
    
    let baseURL: URL
    let parameter: String?
    
    func asURLRequest() throws -> URLRequest {
        guard let parameter = self.parameter else {
            return try self.baseURL.asURLRequest()
        }
        
        let selfType = type(of: self)
        let finalURL = self.baseURL.appendingPathComponent(selfType.path + parameter + selfType.pathExtension)
        return try finalURL.asURLRequest()
    }
}
