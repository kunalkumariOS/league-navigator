//
//  TeamCellViewModel.swift
//  LeagueNavigator
//
//  Created by Dhiman kunal on 19/02/19.
//  Copyright © 2019 Dhiman kunal. All rights reserved.
//

import UIKit

final class TeamCellViewModel {
    
    enum Content {
        case logo(UIImage)
        case color(UIColor)
        case none
    }
    private let team: Team
    private let session: NetworkSession
    
    var name: NSAttributedString {
        return NSAttributedString(string: self.team.fullName)
    }
    
    init(team: Team, session: NetworkSession) {
        self.team = team
        self.session = session
    }
    
    func fetchLogo(then render: @escaping (Content) -> Void) {
        if let logoURL = self.team.logo {
            self.session.execute(request: logoURL) { [weak self] result in
                switch result {
                case .success(let data):
                    performOnMain {
                        guard let logoImage = UIImage(data: data) else {
                            self?.preparePlaceHolderView(then: render)
                            return
                        }
                        render(.logo(logoImage))
                    }
                case .failed:
                    self?.preparePlaceHolderView(then: render)
                }
            }
        }
    }
    
    private func preparePlaceHolderView(then render: @escaping (Content) -> Void) {
        guard let primeryColor = self.team.primeryColour else {
            render(.none)
            return
        }
        render(.color(UIColor.fromHexString(primeryColor)))
    }
}
