//
//  LoginNetwork.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/8/22.
//

import Foundation
import Alamofire

public final class LoginNetwork {
    
    /// Singleton shared Instance
    static let shared = LoginNetwork()
    
    /// Set URL based on the Environment
    
    
    /// Request to get access token after successful Login
    func login(email: String, password: String, onCompletion: @escaping(_ data: LoginResponse?, _ error: Error?) -> Void) {
        
        guard let loginURL = URL(string: getHostname() + "/api/login/canvasser") else {
            onCompletion(nil, NSError(domain: "LoginURLErrorDomain", code: 400, userInfo: nil))
            return
        }
        
        let parameters = ["email": email, "password": password]
        let headers: HTTPHeaders = ["content-type": "application/json"]
        
        AlamofireRequest.shared.request(url: loginURL, method: .post, headers: headers, parameters: parameters) { data, error in
            if (error != nil) {
                onCompletion(nil, error)
            } else if let responseData = data {
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: responseData)
                    onCompletion(loginResponse, nil)
                } catch let error {
                    onCompletion(nil, error)
                }
            }
        }
    }
    
    /// Discover Reader
    func discoverReader(onCompletion: @escaping(_ data: LoginResponse?, _ error: Error?) -> Void) {
        
        guard let loginURL = URL(string: getHostname() + "/api/login/canvasser") else {
            onCompletion(nil, NSError(domain: "LoginURLErrorDomain", code: 400, userInfo: nil))
            return
        }
        
        let parameters = ["email": "fd", "password": "fgd"]
        
        AlamofireRequest.shared.request(url: loginURL, method: .post, parameters: parameters) { data, error in
            if (error != nil) {
                onCompletion(nil, error)
            } else if let responseData = data {
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: responseData)
                    onCompletion(loginResponse, nil)
                } catch let error {
                    onCompletion(nil, error)
                }
            }
        }
    }
    
    /// Connect to Reader
    public func connectToReader(onCompletion: @escaping(_ data: Data?, _ error: NSError?) -> Void) {
        
    }
}
