//
//  League.swift
//  LeagueNavigator
//
//  Created by Dhiman kunal on 18/02/19.
//  Copyright © 2019 Dhiman kunal. All rights reserved.
//

import Foundation

struct League {
    let fullName: String
    let slug: String
}

extension League: Decodable {    
    private enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case slug
    }
}
