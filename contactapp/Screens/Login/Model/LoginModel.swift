//
//  LoginModel.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/8/22.
//

import Foundation

struct LoginResponse: Codable {
    let tokens: TokensResponse?
    let title: String?
    let message: String?
    let status: Bool
}

struct TokensResponse: Codable {
    let token_type: String?
    let expires_in: Double?
    let access_token: String?
    let refresh_token: String?
}
