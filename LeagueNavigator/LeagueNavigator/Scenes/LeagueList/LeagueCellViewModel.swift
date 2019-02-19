//
//  LeagueCellViewModel.swift
//  LeagueNavigator
//
//  Created by Dhiman kunal on 19/02/19.
//  Copyright © 2019 Dhiman kunal. All rights reserved.
//

import Foundation

protocol LeagueCellViewModelType {
    
    var fullName: NSAttributedString { get }
}

struct LeagueCellViewModel: LeagueCellViewModelType {
    
    private let league: League
    
    init(league: League) {
        self.league = league
    }
    
    var fullName: NSAttributedString {
        return NSAttributedString(string: self.league.fullName)
    }
}
