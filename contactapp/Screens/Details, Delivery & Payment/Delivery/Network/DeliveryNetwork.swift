//
//  DeliveryNetwork.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/8/22.
//

import Foundation
import Alamofire

public final class DeliveryNetwork {
    
    /// Singleton shared Instance
    static let shared = DeliveryNetwork()
    
    /// Postal Code Check
    func checkPostalCode(postalCode: String, friendCode: String, onCompletion: @escaping(_ data: EmailResponseModel?, _ error: Error?) -> Void) {
        
        guard let postalCodeCheckURL = URL(string: getHostname() + "/api/taxes") else {
            onCompletion(nil, NSError(domain: "RegionsURLErrorDomain", code: 400, userInfo: nil))
            return
        }
        
        let parameters: Parameters = [
            "postcode": postalCode,
            "friend_code": friendCode
        ]
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "country": "USA"
        ]
        
        AlamofireRequest.shared.request(url: postalCodeCheckURL, method: .post, headers: headers, parameters: parameters) { data, error in
            if (error != nil) {
                onCompletion(nil, error)
            } else if let responseData = data {
                do {
                    let emailResponse = try JSONDecoder().decode(EmailResponseModel.self, from: responseData)
                    onCompletion(emailResponse, nil)
                } catch let error {
                    onCompletion(nil, error)
                }
            }
        }
    }
    
    /// Get Delivery Dates
    func getDeliveryDates(postalCode: String, onCompletion: @escaping(_ data: DeliveryDatesModel?, _ error: Error?) -> Void) {
        
        guard let deliveryDatesURL = URL(string: getHostname() + "/api/postcodes/\(postalCode)/delivery-days/3") else {
            onCompletion(nil, NSError(domain: "RegionsURLErrorDomain", code: 400, userInfo: nil))
            return
        }
        
        let headers: HTTPHeaders = [
            "content-type": "application/json"
        ]
        
        AlamofireRequest.shared.request(url: deliveryDatesURL, method: .get, headers: headers) { data, error in
            if (error != nil) {
                onCompletion(nil, error)
            } else if let responseData = data {
                do {
                    let deliveryDatesResponse = try JSONDecoder().decode(DeliveryDatesModel.self, from: responseData)
                    onCompletion(deliveryDatesResponse, nil)
                } catch let error {
                    onCompletion(nil, error)
                }
            }
        }
    }
    
    /// Telephone Number Check
    func checkTelephoneNumber(telephone: String, onCompletion: @escaping(_ data: PhoneNumberModel?, _ error: Error?) -> Void) {
        
        guard let telephoneURL = URL(string: getHostname() + "/api/taxes") else {
            onCompletion(nil, NSError(domain: "RegionsURLErrorDomain", code: 400, userInfo: nil))
            return
        }
        
        let parameters: Parameters = [
            "telephone": telephone
        ]
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "country": "USA"
        ]
        
        AlamofireRequest.shared.request(url: telephoneURL, method: .post, headers: headers, parameters: parameters) { data, error in
            if (error != nil) {
                onCompletion(nil, error)
            } else if let responseData = data {
                do {
                    let emailResponse = try JSONDecoder().decode(PhoneNumberModel.self, from: responseData)
                    onCompletion(emailResponse, nil)
                } catch let error {
                    onCompletion(nil, error)
                }
            }
        }
    }
    
    /// Offer Code
    func offerCode(postalCode: String, friendCode: String, onCompletion: @escaping(_ data: OfferCodeResponse?, _ error: Error?) -> Void) {
        
        guard let offerCodeCheckURL = URL(string: getHostname() + "/api/taxes") else {
            onCompletion(nil, NSError(domain: "RegionsURLErrorDomain", code: 400, userInfo: nil))
            return
        }
        
        let parameters: Parameters = [
            "postcode": postalCode,
            "friend_code": friendCode
        ]
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "country": "USA"
        ]
        
        AlamofireRequest.shared.request(url: offerCodeCheckURL, method: .post, headers: headers, parameters: parameters) { data, error in
            if (error != nil) {
                onCompletion(nil, error)
            } else if let responseData = data {
                do {
                    let offerCodeResponse = try JSONDecoder().decode(OfferCodeResponse.self, from: responseData)
                    onCompletion(offerCodeResponse, nil)
                } catch let error {
                    onCompletion(nil, error)
                }
            }
        }
    }
    
    /// Sign Up Delivery Details
    func signUpDelivery(details: CustomerDetails, onCompletion: @escaping(_ data: DeliveryResponseModel?, _ error: Error?) -> Void) {
        
        guard let offerCodeCheckURL = URL(string: getHostname() + "/api/users/validate/registration/delivery") else {
            onCompletion(nil, NSError(domain: "RegionsURLErrorDomain", code: 400, userInfo: nil))
            return
        }
        
        var parameters: Parameters = [
            "first_name": details.firstName ?? "",
            "last_name": details.lastName ?? "",
            "email": details.email ?? "",
            "telephone": details.telephone ?? ""
        ]
        
        if let deliveryDetails = details.delivery {
            parameters["delivery_address_house_number"] = deliveryDetails.deliveryAddressHouseNumber ?? ""
            parameters["delivery_address_line_1"] = deliveryDetails.deliveryAddressLineOne ?? ""
            parameters["delivery_address_line_2"] = deliveryDetails.deliveryAddressLineTwo ?? ""
            parameters["delivery_address_city"] = deliveryDetails.deliveryAddressCity ?? ""
            parameters["delivery_address_postcode"] = deliveryDetails.deliveryAddressPostalCode ?? ""
            parameters["delivery_address_state"] = deliveryDetails.deliveryAddressState ?? ""
            parameters["delivery_address_country"] = deliveryDetails.deliveryAddressCountry
            parameters["delivery_address_country_iso"] = deliveryDetails.deliveryAddressCountryISO
            parameters["delivery_address_property_type"] = deliveryDetails.deliveryAddressPropertyType ?? ""
            parameters["delivery_instructions"] = deliveryDetails.deliveryInstructions ?? ""
        }
        
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "country": "USA"
        ]
        
        AlamofireRequest.shared.request(url: offerCodeCheckURL, method: .post, headers: headers, parameters: parameters) { data, error in
            if (error != nil) {
                onCompletion(nil, error)
            } else if let responseData = data {
                do {
                    let offerCodeResponse = try JSONDecoder().decode(DeliveryResponseModel.self, from: responseData)
                    onCompletion(offerCodeResponse, nil)
                } catch let error {
                    onCompletion(nil, error)
                }
            }
        }
    }
}
