//
//  Team.swift
//  LeagueNavigator
//
//  Created by Dhiman kunal on 18/02/19.
//  Copyright © 2019 Dhiman kunal. All rights reserved.
//

import Foundation

struct Team {
    let name: String
    let fullName: String
    let location: String
    let logo: URL?
    let primeryColour: String?
    let seconderyColor: String?
}

extension Team: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
        case location
        case logo
        case primeryColour
        case seconderyColor
    }
}
