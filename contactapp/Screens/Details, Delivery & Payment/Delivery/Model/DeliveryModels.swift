//
//  DeliveryModels.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 4/8/22.
//

import Foundation

struct PostalCodeModel: Codable {
    let title: String?
    let message: String?
    let status: Bool?
}

struct DeliveryDatesModel: Codable {
    let title: String?
    let type: String?
    let items: [DeliveryDatesItem]?
}

struct DeliveryDatesItem: Codable {
    let human: String?
    let value: String?
}

struct PhoneNumberModel: Codable {
    let title: String?
    let message: String?
    let status: Bool?
}

struct OfferCodeResponse: Codable {
    let total_price: Double?
    let tax: Double?
    let price: Double?
    let discounted_total_price: Double?
    let discounted_tax: Double?
    let discounted_price: Double?
    let state: String?
    let shipping_amount: Double?
    let discount_shipping_amount: Double?
}
