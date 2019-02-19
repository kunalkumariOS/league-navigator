//
//  NetworkSession.swift
//  LeagueNavigator
//
//  Created by Dhiman kunal on 18/02/19.
//  Copyright © 2019 Dhiman kunal. All rights reserved.
//

import Foundation

protocol NetworkSession {
    func execute(request: URLRequestConvertable, then handle: @escaping (Result<Data>) -> Void)
}
