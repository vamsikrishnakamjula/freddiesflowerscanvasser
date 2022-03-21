//
//  RegionSourceModel.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/8/22.
//

import Foundation

struct RegionSourceModel {
    let region: String?
    let source: String?
    
    init(region: String, source: String) {
        self.region = region
        self.source = source
    }
}
