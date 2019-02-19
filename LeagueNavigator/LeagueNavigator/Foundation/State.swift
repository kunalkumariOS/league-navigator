//
//  State.swift
//  LeagueNavigator
//
//  Created by Dhiman kunal on 19/02/19.
//  Copyright © 2019 Dhiman kunal. All rights reserved.
//

import Foundation

typealias StateObserver = (State) -> Void

enum State {
    case loading
    case finished
    case failed(Error)
}

