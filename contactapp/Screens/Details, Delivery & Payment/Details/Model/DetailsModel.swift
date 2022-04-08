//
//  DetailsModel.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 4/8/22.
//

import Foundation

struct EmailResponseModel: Codable {
    let title: String?
    let message: String?
    let status: Bool?
}

struct SignUpResponseModel: Codable {
    let title: String?
    let message: String?
    let status: Bool?
}
