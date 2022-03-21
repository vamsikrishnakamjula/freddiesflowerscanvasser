//
//  LoginViewModel.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/8/22.
//

import Foundation

public final class LoginViewModel {
    
    /// Singleton shared Instance
    static let shared = LoginViewModel()
    
    /// Cache Login Response Details
    func cacheRefreshToken(login: LoginResponse) {
        let userDefaults = UserDefaults.standard
        
        if let tokens = login.tokens, let refreshToken = tokens.refresh_token {
            userDefaults.set(refreshToken, forKey: REFRESH_TOKEN_DEFAULTS_KEY)
        }
    }
}
