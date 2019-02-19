//
//  URLSession+NetworkSession.swift
//  LeagueNavigator
//
//  Created by Dhiman kunal on 19/02/19.
//  Copyright © 2019 Dhiman kunal. All rights reserved.
//

import Foundation

extension URLSession: NetworkSession {
    private static let validStatusCode = Set(200...399)
    
    func execute(request: URLRequestConvertable, then handle: @escaping (Result<Data>) -> Void) {
        
        do {
            let urlRequest = try request.asURLRequest()
            let completionHandler: (Data?, URLResponse?, Error?) -> Void = { data, response, error in
                if let error = error {
                    handle(.failed(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    type(of: self).validStatusCode.contains(response.statusCode) else {
                    handle(.failed(NetworkError.ResponseError.invalidResponse))
                    return
                }
                
                guard let data = data else {
                    handle(.failed(NetworkError.ResponseError.invalidResponse))
                    return
                }

                handle(.success(data))
            }
            
            self.dataTask(with: urlRequest, completionHandler: completionHandler).resume()
        } catch {
            handle(.failed(error))
        }
    }
}
