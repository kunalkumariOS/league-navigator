//
//  Request.swift
//  LeagueNavigator
//
//  Created by Dhiman kunal on 18/02/19.
//  Copyright © 2019 Dhiman kunal. All rights reserved.
//

import Foundation

protocol URLRequestConvertable {
    func asURLRequest() throws -> URLRequest
}

extension URL: URLRequestConvertable {
    func asURLRequest() throws -> URLRequest {
        return URLRequest(url: self)
    }
}

protocol ServiceRequest: URLRequestConvertable {
    
    associatedtype ResponseType
    
    var baseURL: URL { get }
    
    func execute(onSession session: NetworkSession, then handle: @escaping (Result<ResponseType>) -> Void)
}

extension ServiceRequest where ResponseType: Decodable {
    func execute(onSession session: NetworkSession, then handle: @escaping (Result<ResponseType>) -> Void) {
        
        let completion: (Result<Data>) -> Void = { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(ResponseType.self, from: data)
                    handle(.success(response))
                } catch {
                    handle(.failed(error))
                }
            case .failed(let error):
                handle(.failed(error))
            }
        }
        
        session.execute(request: self, then: completion)
    }
}

protocol ParameterdRequest: ServiceRequest {
    associatedtype ParameterType
    var parameter: ParameterType? { get }
}
