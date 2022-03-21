//
//  Request.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/8/22.
//

import Foundation
import Alamofire

public final class AlamofireRequest {
    
    /// Singleton shared Instance
    static let shared = AlamofireRequest()
    
    /// Generic Request with Request URL, HTTPS Method, Headers & Paramters
    public func request(url: URL, method: HTTPMethod = .get, parameters: Parameters, onCompletion: @escaping(_ data: Data?, _ error: Error?) -> Void) {
        
        let headers: HTTPHeaders = ["content-type": "application/json"]
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            guard response.result.isSuccess else {
                onCompletion(nil, response.result.error)
                return
            }
            onCompletion(response.data, nil)
        }
    }
}
