//
//  URLSession+Utils.swift
//  Smart Scanner
//
//  Created by Bilguun Batbold on 15/8/19.
//  Copyright © 2019 ISEM. All rights reserved.
//
import UIKit

extension URLSession {
    
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        
        return dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            
            result(.success((response, data)))
        })
    }
}
