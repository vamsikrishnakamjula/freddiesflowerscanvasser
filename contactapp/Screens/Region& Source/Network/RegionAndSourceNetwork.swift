//
//  RegionAndSourceNetwork.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/8/22.
//

import Foundation

final class RegionAndSourceNetwork {
    
    /// Singleton shared Instance
    let shared = LoginNetwork()
    let userDefaults = UserDefaults.standard
    
    /// Get Regions
    public func getRegions(onCompletion: @escaping(_ data: Data?, _ error: NSError?) -> Void) {
        
        guard let refreshToken = userDefaults.value(forKey: REFRESH_TOKEN_DEFAULTS_KEY) else {
            onCompletion(nil, nil)
            return
        }
    }
    
    /// Get Sources
    public func getSources(onCompletion: @escaping(_ data: Data?, _ error: NSError?) -> Void) {
        
        guard let refreshToken = userDefaults.value(forKey: REFRESH_TOKEN_DEFAULTS_KEY) else {
            onCompletion(nil, nil)
            return
        }
    }
}
