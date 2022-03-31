//
//  RegionSourceModel.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/8/22.
//

import Foundation

struct RegionsModel: Codable {
    let data: [RegionsData]?
}

struct RegionsData: Codable {
    let id: Int?
    let name: String?
}

struct SourcesModel: Codable {
    let data: [RegionsData]?
}

struct SourcesData: Codable {
    let id: Int?
    let name: String?
    let card_required: Bool?
}
