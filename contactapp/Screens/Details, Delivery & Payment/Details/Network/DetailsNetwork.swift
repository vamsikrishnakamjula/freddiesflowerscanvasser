//
//  DetailsNetwork.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/8/22.
//

import Foundation
import Alamofire

public final class DetailsNetwork {
    
    /// Singleton shared Instance
    static let shared = DetailsNetwork()
    
    /// Email Check
    func checkEmail(email: String, onCompletion: @escaping(_ data: EmailResponseModel?, _ error: Error?) -> Void) {
        
        guard let emailCheckURL = URL(string: getHostname() + "/api/validate/email") else {
            onCompletion(nil, NSError(domain: "RegionsURLErrorDomain", code: 400, userInfo: nil))
            return
        }
        
        let parameters: Parameters = [
            "email": email
        ]
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "country": "USA"
        ]
        
        AlamofireRequest.shared.request(url: emailCheckURL, method: .post, headers: headers, parameters: parameters) { data, error in
            if (error != nil) {
                onCompletion(nil, error)
            } else if let responseData = data {
                do {
                    let emailResponse = try JSONDecoder().decode(EmailResponseModel.self, from: responseData)
                    onCompletion(emailResponse, nil)
                } catch let error {
                    onCompletion(nil, error)
                }
            }
        }
    }
    
    func signUp(details: CustomerDetails, onCompletion: @escaping(_ data: SignUpResponseModel?, _ error: Error?) -> Void) {
        
        guard let signUpURL = URL(string: getHostname() + "/api/users/validate/registration/introductions") else {
            onCompletion(nil, NSError(domain: "RegionsURLErrorDomain", code: 400, userInfo: nil))
            return
        }
        
        let parameters: Parameters = [
            "email": details.email ?? "",
            "first_name": details.firstName ?? "",
            "last_name": details.lastName ?? "",
            "opt_in_marketing": details.optInMarketing ?? false,
            "opt_in_third_party_marketing": details.optInThirdPartyMarketing ?? false,
            "password": details.password ?? "",
            "telephone": details.telephone ?? ""
        ]
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "country": "USA"
        ]
        
        AlamofireRequest.shared.request(url: signUpURL, method: .post, headers: headers, parameters: parameters) { data, error in
            if (error != nil) {
                onCompletion(nil, error)
            } else if let responseData = data {
                do {
                    let signUpResponse = try JSONDecoder().decode(SignUpResponseModel.self, from: responseData)
                    onCompletion(signUpResponse, nil)
                } catch let error {
                    onCompletion(nil, error)
                }
            }
        }
    }
}
