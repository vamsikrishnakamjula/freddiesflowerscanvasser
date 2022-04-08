//
//  CustomerDetails.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 4/9/22.
//

import Foundation

struct CustomerDetails {
    let firstName: String?
    let lastName: String?
    let email: String?
    let password: String?
    let telephone: String?
    let optInMarketing: Bool?
    let optInThirdPartyMarketing: Bool?
    let delivery: DeliveryDetails?
    let offer: OfferDetails?
}

struct DeliveryDetails {
    let deliveryAddressHoseNumber: String?
    let deliveryAddressLineOne: String?
    let deliveryAddressLineTwo: String?
    let deliveryAddressCity: String?
    let deliveryAddressPostalCode: String?
    let deliveryAddressState: String?
    let deliveryAddressCountry: String?
    let deliveryAddressCountryISO: String?
    let deliveryAddressPropertyType: String?
    let deliveryInstructions: String?
}

struct OfferDetails {
    let friendCode: String?
}
