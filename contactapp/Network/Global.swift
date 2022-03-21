//
//  Global.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/9/22.
//

import Foundation

/// User Defaults Keys
let REFRESH_TOKEN_DEFAULTS_KEY = "refreshToken"

enum Environment: String {
    case prod
    case stage
}

let hostname: [Environment: String] = [
    .prod: "https://api.uat.us.freddiesflowers.com",
    .stage: "https://api.uat.us.freddiesflowers.com"
]

func getEnvironment() -> Environment {
    if let env = Bundle.main.object(forInfoDictionaryKey: "Environment") as? String, env == "stage" {
        return .stage
    } else {
        return .prod
    }
}

public func getHostname() -> String {
    return hostname[getEnvironment()] ?? ""
}
