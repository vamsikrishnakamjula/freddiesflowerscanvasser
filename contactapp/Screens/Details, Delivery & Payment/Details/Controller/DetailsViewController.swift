//
//  DetailsViewController.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/7/22.
//

import UIKit

class DetailsViewController: UIViewController {

    /// Outlets - Input Fields
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnTap()
    }
    
    /// Reset Registration Button Touched
    @IBAction func resetRegistrationBtnTouched(_ sender: UIButton) {
        
    }
    
    /// Promotions Switch Changes
    @IBAction func promotionsSwtichChanged(_ sender: UISwitch) {
        
    }
    
    /// Privacy Button Touched
    @IBAction func privacyPolicyBtnTouched(_ sender: UIButton) {
        
    }
    
    /// Next Step Button Touched
    @IBAction func nextStepBtnTouched(_ sender: UIButton) {
        
    }
    
    /// Hide Pasword Button Touched
    @IBAction func hidePasswordTouced(_ sender: UIButton) {
        
    }
    
    /// Logout Button Touched
    @IBAction func logoutBtnTouched(_ sender: UIButton) {
        
    }
}
