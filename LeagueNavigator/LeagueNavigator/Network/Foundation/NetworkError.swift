//
//  NetworkError.swift
//  LeagueNavigator
//
//  Created by Dhiman kunal on 18/02/19.
//  Copyright © 2019 Dhiman kunal. All rights reserved.
//

import Foundation

enum NetworkError {
    enum URLConversionError: Error {
        case unableToConvertAsURL
    }
    
    enum ResponseError: Error {
        case invalidResponse
    }
}
