//
//  DeliveryViewController.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/2/22.
//

import UIKit

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
    
    /// Outlets - Segment Controls
    @IBOutlet weak var buildingSegmentContrl: UISegmentedControl!
    
    /// Outlets - Text View
    @IBOutlet weak var notAtHomeNotesView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureUI()
    }
    
    fileprivate func configureUI() {
        self.hideKeyboardOnTap()
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        
        self.deliveryScrollView.keyboardDismissMode = .onDrag
        
        for segmentItem: UIView in self.buildingSegmentContrl.subviews {
            for item : Any in segmentItem.subviews {
                if let i = item as? UILabel {
                    i.numberOfLines = 0
                    i.font = UIFont(name: "Avenir-Medium", size: 20.0)!
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
        self.phoneNumberTxtField.text = ""
        self.freshWeeklyFlowersLbl.text = "$00.00"
        self.deliveryLbl.text = "$00.00"
        self.salesTaxLbl.text = "$00.00"
        self.totalLbl.text = "$00.00"
        self.offerCodeTxtField.text = ""
    }
    
    /// Promotions Switch Changes
    @IBAction func promotionsSwtichChanged(_ sender: UISwitch) {
        
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
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "toPaymentDetailsSegue", sender: nil)
        }
    }
    
    /// Add Offer Code Button Touched
    @IBAction func addOfferCodeBtnTouched(_ sender: UIButton) {
        
    }
    
    /// Offer Apply Button Touched
    @IBAction func offerApplyBtnTouched(_ sender: UIButton) {
        
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
