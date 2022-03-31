//
//  RegionAndSourceNetwork.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/8/22.
//

import Foundation
import Alamofire

public final class RegionAndSourceNetwork {
    
    /// Singleton shared Instance
    static let shared = RegionAndSourceNetwork()
    
    /// Get Regions
    func getRegions(onCompletion: @escaping(_ data: RegionsModel?, _ error: Error?) -> Void) {
        
        guard let regionsURL = URL(string: getHostname() + "/api/canvassers/regions") else {
            onCompletion(nil, NSError(domain: "RegionsURLErrorDomain", code: 400, userInfo: nil))
            return
        }
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "country": "USA"
        ]
        
        AlamofireRequest.shared.request(url: regionsURL, method: .get, headers: headers) { data, error in
            if (error != nil) {
                onCompletion(nil, error)
            } else if let responseData = data {
                do {
                    let regionsResponse = try JSONDecoder().decode(RegionsModel.self, from: responseData)
                    onCompletion(regionsResponse, nil)
                } catch let error {
                    onCompletion(nil, error)
                }
            }
        }
    }
    
    /// Get Sources
    func getSources(onCompletion: @escaping(_ data: SourcesModel?, _ error: Error?) -> Void) {
        
        guard let sourcesURL = URL(string: getHostname() + "/api/canvassers/sources") else {
            onCompletion(nil, NSError(domain: "SourcesURLErrorDomain", code: 400, userInfo: nil))
            return
        }
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "country": "USA"
        ]
        
        AlamofireRequest.shared.request(url: sourcesURL, method: .get, headers: headers) { data, error in
            if (error != nil) {
                onCompletion(nil, error)
            } else if let responseData = data {
                do {
                    let sourcesResponse = try JSONDecoder().decode(SourcesModel.self, from: responseData)
                    onCompletion(sourcesResponse, nil)
                } catch let error {
                    onCompletion(nil, error)
                }
            }
        }
    }
}
