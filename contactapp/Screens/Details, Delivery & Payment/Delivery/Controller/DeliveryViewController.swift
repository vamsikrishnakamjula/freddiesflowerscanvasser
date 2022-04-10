//
//  DeliveryViewController.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/2/22.
//

import UIKit
import ActionSheetPicker_3_0

class DeliveryViewController: UIViewController {

    /// Outlets - Input Fields
    @IBOutlet weak var deliveryScrollView: UIScrollView!
    @IBOutlet weak var addressTxtField: UITextField!
    @IBOutlet weak var apartmentOrSuiteTxtField: UITextField!
    @IBOutlet weak var zipCodeTxtField: UITextField!
    @IBOutlet weak var townOrCityTxtField: UITextField!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var promotionsSwitch: UISwitch!
    @IBOutlet weak var firstDeliveryLbl: UILabel!
    @IBOutlet weak var privacyLbl: UILabel!
    @IBOutlet weak var phoneNumberTxtField: UITextField!
    @IBOutlet weak var freshWeeklyFlowersLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var salesTaxLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var offerCodeTxtField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /// Outlets - Stack View
    @IBOutlet weak var offerCodeStkView: UIStackView!
    
    /// Outlets - Segment Controls
    @IBOutlet weak var buildingSegmentContrl: UISegmentedControl!
    
    /// Outlets - Text View
    @IBOutlet weak var notAtHomeNotesView: UITextView!
    
    /// Stored Properties
    var states: [String] = ["California"]
    var deliveryDates = [DeliveryDatesItem]()
    var deliveryOptions = [String]()
    var buildingOptions: [String] = ["House", "Townhouse or apartment", "Office or commercial building"]
    var customerDetails: CustomerDetails?
    
    /// Delegate
    var delegate: SuperViewDetailsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureUI()
        print(customerDetails)
    }
    
    fileprivate func configureUI() {
        self.hideKeyboardOnTap()
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        self.offerCodeStkView.isHidden = true
        
        self.deliveryScrollView.setContentOffset(CGPoint.zero, animated: true)
        self.deliveryScrollView.keyboardDismissMode = .onDrag
        
        for segmentItem: UIView in self.buildingSegmentContrl.subviews {
            for item : Any in segmentItem.subviews {
                if let btnTitleLbl = item as? UILabel {
                    btnTitleLbl.numberOfLines = 0
                    btnTitleLbl.font = UIFont(name: "Avenir-Medium", size: 20.0)!
                }
            }
        }
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            self.privacyLbl.highlight(text: "Privacy Policy", font: UIFont(name: "Avenir-Medium", size: 15.0)!, color: UIColor.blue)
        case .pad:
            self.privacyLbl.highlight(text: "Privacy Policy", font: UIFont(name: "Avenir-Medium", size: 20.0)!, color: UIColor.blue)
        default:
            self.privacyLbl.highlight(text: "Privacy Policy", font: UIFont(name: "Avenir-Medium", size: 15.0)!, color: UIColor.blue)
        }
    }
    
    fileprivate func getDeliveryDays(postalCode: String) {
        /// Get Delivery Dates
        DeliveryNetwork.shared.getDeliveryDates(postalCode: postalCode) { data, error in
            if (error != nil) {
                self.presentAlert(title: "Postal Code - Delivery Dates Error", message: error?.localizedDescription ?? "")
            } else if let deliveryDatesResponseData = data, let deliveryDateItems = deliveryDatesResponseData.items {
                if (deliveryDateItems.count == 0) {
                    self.presentAlert(title: "No Delivery Dates Available", message: error?.localizedDescription ?? "")
                } else {
                    self.deliveryDates = deliveryDateItems
                    for dateItem in deliveryDateItems {
                        self.deliveryOptions.append("\(dateItem.human ?? "")")
                    }
                }
            }
        }
    }
    
    fileprivate func checkOfferCode(postalCode: String, offerCode: String) {
        DeliveryNetwork.shared.offerCode(postalCode: postalCode, friendCode: offerCode) { data, error in
            if (error != nil) {
                self.presentAlert(title: "Offer Code Error", message: error?.localizedDescription ?? "")
            } else if let responseData = data {
                self.updateOrderSummary(offerCodeResponse: responseData)
            }
        }
    }
    
    fileprivate func updateOrderSummary(offerCodeResponse: OfferCodeResponse) {
        if let price = offerCodeResponse.price, let discountedPrice = offerCodeResponse.discounted_price {
            self.freshWeeklyFlowersLbl.text = "$\(price) $\(price - discountedPrice)"
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                self.freshWeeklyFlowersLbl.highlight(text: "$\(price)", font: UIFont(name: "Avenir-Medium", size: 20.0)!, color: UIColor.red)
            case .pad:
                self.freshWeeklyFlowersLbl.highlight(text: "$\(price)", font: UIFont(name: "Avenir-Medium", size: 25.0)!, color: UIColor.red)
            default:
                self.freshWeeklyFlowersLbl.highlight(text: "$\(price)", font: UIFont(name: "Avenir-Medium", size: 20.0)!, color: UIColor.red)
            }
            self.totalLbl.text = "$\(price - discountedPrice)"
        }
        
        if let tax = offerCodeResponse.tax, let discountedTax = offerCodeResponse.discounted_tax {
            self.salesTaxLbl.text = "\(tax) \(tax - discountedTax)"
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                self.salesTaxLbl.highlight(text: "\(tax)", font: UIFont(name: "Avenir-Medium", size: 20.0)!, color: UIColor.red)
            case .pad:
                self.salesTaxLbl.highlight(text: "\(tax)", font: UIFont(name: "Avenir-Medium", size: 25.0)!, color: UIColor.red)
            default:
                self.salesTaxLbl.highlight(text: "\(tax)", font: UIFont(name: "Avenir-Medium", size: 20.0)!, color: UIColor.red)
            }
        }
        
        self.deliveryLbl.text = "Free"
    }
    
    /// Reset Registration Button Touched
    @IBAction func resetRegistrationBtnTouched(_ sender: UIButton) {
        self.resetInputFields()
    }
    
    fileprivate func resetInputFields() {
        self.addressTxtField.text = ""
        self.apartmentOrSuiteTxtField.placeholder = "(optional)"
        self.zipCodeTxtField.text = ""
        self.townOrCityTxtField.text = ""
        self.stateLbl.text = "State"
        self.firstDeliveryLbl.text = "Please select first delivery day"
        self.firstDeliveryLbl.textColor = UIColor.lightGray
        self.phoneNumberTxtField.text = ""
        self.freshWeeklyFlowersLbl.text = "$44"
        self.deliveryLbl.text = "Free"
        self.salesTaxLbl.text = "$TBC"
        self.totalLbl.text = "$44"
        self.offerCodeTxtField.text = ""
        self.offerCodeStkView.isHidden = true
    }
    
    @IBAction func stateBtnTouched(_ sender: UIButton) {
        ActionSheetStringPicker.show(withTitle: "States",
                                     rows: states,
                                             initialSelection: 0,
                                             doneBlock: { picker, index, value in
                                            self.stateLbl.text = self.states[index]
                                            self.stateLbl.textColor = UIColor.black
                                                return
                                             },
                                             cancel: { picker in
                                                return
                                             },
                                             origin: sender)
    }
    
    /// Privacy Button Touched
    @IBAction func privacyPolicyBtnTouched(_ sender: UIButton) {
        self.presentPrivacyPolicyView()
    }
    
    @IBAction func firstDeliveryArriveBtnTouched(_ sender: UIButton) {
        if let postalCode = self.zipCodeTxtField.text, postalCode == "" {
            self.presentAlert(title: "Error!", message: "Please enter postal code for delivery dates availability.")
        } else {
            ActionSheetStringPicker.show(withTitle: "First Delivery Day",
                                         rows: self.deliveryOptions,
                                                 initialSelection: 0,
                                                 doneBlock: { picker, index, value in
                                                self.firstDeliveryLbl.text = self.deliveryOptions[index]
                                                self.firstDeliveryLbl.textColor = UIColor.black
                                                    return
                                                 },
                                                 cancel: { picker in
                                                    return
                                                 },
                                                 origin: sender)
        }
    }
    
    /// Sign Me Up Button Touched
    @IBAction func signMeUpBtnTouched(_ sender: UIButton) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        sender.isEnabled = false
        let errorMessage = self.validateInputFields()
        if (errorMessage != "") {
            self.presentAlert(title: "Error!", message: errorMessage)
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            sender.isEnabled = true
        } else {
            if let details = self.customerDetails {
                let deliveryDetails = DeliveryDetails(deliveryAddressHouseNumber: "", deliveryAddressLineOne: self.addressTxtField.text ?? "", deliveryAddressLineTwo: self.apartmentOrSuiteTxtField.text ?? "", deliveryAddressCity: self.townOrCityTxtField.text ?? "", deliveryAddressPostalCode: self.zipCodeTxtField.text ?? "", deliveryAddressState: self.stateLbl.text ?? "", deliveryAddressCountry: "", deliveryAddressCountryISO: "", deliveryAddressPropertyType: self.buildingOptions[self.buildingSegmentContrl.selectedSegmentIndex], deliveryInstructions: self.notAtHomeNotesView.text ?? "")
                let offerDetails = OfferDetails(friendCode: self.offerCodeTxtField.text ?? "")
                let customerDetails = CustomerDetails(firstName: details.firstName, lastName: details.lastName, email: details.email, password: details.password, telephone: self.phoneNumberTxtField.text ?? "", optInMarketing: self.promotionsSwitch.isOn, optInThirdPartyMarketing: self.promotionsSwitch.isOn, delivery: deliveryDetails, offer: offerDetails)
                DeliveryNetwork.shared.checkTelephoneNumber(telephone: self.phoneNumberTxtField.text ?? "") { data, error in
                    if (error != nil) {
                        self.presentAlert(title: "Sources Error", message: error?.localizedDescription ?? "")
                    } else if let responseData = data {
                        if let success = responseData.status, success {
                            /// Success Navigation to Delivery details
                            self.delegate?.updateCustomerDetails(details: customerDetails, yourDetails: false, delivery: false, paymentDetails: true)
                        } else {
                            self.presentAlert(title: "Error!", message: "Please check Telephone number, please try again.")
                        }
                    }
                }
            } else {
                self.presentAlert(title: "Error!", message: "Something went wrong, please try again later.")
            }
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            sender.isEnabled = true
        }
    }
    
    /// Add Offer Code Button Touched
    @IBAction func addOfferCodeBtnTouched(_ sender: UIButton) {
        if (sender.isSelected) {
            sender.isSelected = false
            self.offerCodeStkView.isHidden = true
        } else {
            sender.isSelected = true
            self.offerCodeStkView.isHidden = false
        }
    }
    
    /// Offer Apply Button Touched
    @IBAction func offerApplyBtnTouched(_ sender: UIButton) {
        if let offerCode = self.offerCodeTxtField.text, offerCode == "",
           let postalCode = self.zipCodeTxtField.text, postalCode == "" {
            self.presentAlert(title: "Error!", message: "Please enter Offer code & Postal Code.")
        } else {
            self.checkOfferCode(postalCode: self.zipCodeTxtField.text ?? "", offerCode: self.offerCodeTxtField.text ?? "")
        }
    }
    
    /// Logout Button Touched
    @IBAction func logoutBtnTouched(_ sender: UIButton) {
        self.presentLogoutAlert()
    }
    
    /// Check for required input fields
    fileprivate func validateInputFields() -> String {
        if let address = self.addressTxtField.text, address == "" {
            return "Please enter valid address."
        }
        
        if let zipcode = self.zipCodeTxtField.text, zipcode == "" {
            return "Please enter valid Zipcode."
        }
        
        if let town = self.townOrCityTxtField.text, town == "" {
            return "Please enter valid Town or City."
        }
        
        if let state = self.stateLbl.text, state == "State" {
            return "Please enter valid State."
        }
        
        if let firstDelivery = self.firstDeliveryLbl.text, firstDelivery == "" {
            return "Please select First Delivery option."
        }
        
        if (self.buildingSegmentContrl.selectedSegmentIndex == -1) {
            return "Please select kind of building will our drivers be delivering to?"
        }
        
        if let notAtHomeNotes = self.notAtHomeNotesView.text, notAtHomeNotes == "" {
            return "Please add comment where we should we leave your flowers if you're not home?"
        }
        
        if let phoneNumber = self.phoneNumberTxtField.text, phoneNumber == "" {
            return "Please enter valid Phone Number."
        }
        
        return ""
    }
}

extension DeliveryViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.zipCodeTxtField) {
            self.getDeliveryDays(postalCode: self.zipCodeTxtField.text ?? "")
        }
    }
}
