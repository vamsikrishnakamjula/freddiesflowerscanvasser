//
//  DeliveryViewController.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/2/22.
//

import UIKit

class DeliveryViewController: UIViewController {

    /// Outlets - Input Fields
    @IBOutlet weak var addressTxtField: UITextField!
    @IBOutlet weak var apartmentOrSuiteTxtField: UITextField!
    @IBOutlet weak var zipCodeTxtField: UITextField!
    @IBOutlet weak var townOrCityTxtField: UITextField!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var firstDeliveryLbl: UILabel!
    @IBOutlet weak var phoneNumberTxtField: UITextField!
    @IBOutlet weak var freshWeeklyFlowersLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var salesTaxLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var offerCodeTxtField: UITextField!
    
    /// Outlets - Segment Controls
    @IBOutlet weak var buildingSegmentContrl: UISegmentedControl!
    
    /// Outlets - Text View
    @IBOutlet weak var notAtHomeNotesView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnTap()
    }
    
    /// Promotions Switch Changes
    @IBAction func promotionsSwtichChanged(_ sender: UISwitch) {
        
    }
    
    /// Sign Me Up Button Touched
    @IBAction func signMeUpBtnTouched(_ sender: UIButton) {
        
    }
    
    /// Add Offer Code Button Touched
    @IBAction func addOfferCodeBtnTouched(_ sender: UIButton) {
        
    }
    
    /// Offer Apply Button Touched
    @IBAction func offerApplyBtnTouched(_ sender: UIButton) {
        
    }
    
    /// Logout Button Touched
    @IBAction func logoutBtnTouched(_ sender: UIButton) {
        
    }
}
