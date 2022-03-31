//
//  DetailsViewController.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/7/22.
//

import UIKit

class DetailsViewController: UIViewController {

    /// Outlets - Input Fields
    @IBOutlet weak var detailsScrollView: UIScrollView!
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var promotionsSwitch: UISwitch!
    @IBOutlet weak var privacyLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /// Stored Properties
    var region = ""
    var source = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureUI()
    }
    
    fileprivate func configureUI() {
        self.setupNavigationUI()
        self.hideKeyboardOnTap()
        self.detailsScrollView.keyboardDismissMode = .onDrag
        
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        
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
        self.firstNameTxtField.text = ""
        self.lastNameTxtField.text = ""
        self.emailTxtField.text = ""
        self.passwordTxtField.text = ""
    }
    
    /// Promotions Switch Changes
    @IBAction func promotionsSwitchChanged(_ sender: UISwitch) {
        
    }
    
    /// Privacy Button Touched
    @IBAction func privacyPolicyBtnTouched(_ sender: UIButton) {
        
    }
    
    /// Next Step Button Touched
    @IBAction func nextStepBtnTouched(_ sender: UIButton) {
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
            self.performSegue(withIdentifier: "toDeliverySegue", sender: nil)
        }
    }
    
    /// Hide Pasword Button Touched
    @IBAction func hidePasswordTouced(_ sender: UIButton) {
        if (sender.isSelected) {
            sender.isSelected = false
            self.passwordTxtField.isSecureTextEntry = true
        } else {
            sender.isSelected = true
            self.passwordTxtField.isSecureTextEntry = false
        }
    }
    
    /// Logout Button Touched
    @IBAction func logoutBtnTouched(_ sender: UIBarButtonItem) {
        self.presentLogoutAlert()
    }
    
    fileprivate func validateInputFields() -> String {
        if let firstName = self.firstNameTxtField.text, firstName == "" {
            return "Please enter valid First Name."
        }
        
        if let lastName = self.lastNameTxtField.text, lastName == "" {
            return "Please enter valid Last Name."
        }
        
        if let email = self.emailTxtField.text {
            if (email == "" || !self.isValidEmail(email: email)) {
                return "Please enter valid email."
            }
        }
        
        if let password = self.passwordTxtField.text, password == "" {
            return "Please enter valid Password."
        }
        
        return ""
    }
    
    /// Remove Keyboard when Scroll View position changed
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.isEqual(self.detailsScrollView)) {
            switch scrollView.panGestureRecognizer.state {
            case .changed:
                self.firstNameTxtField.resignFirstResponder()
                self.lastNameTxtField.resignFirstResponder()
                self.emailTxtField.resignFirstResponder()
                self.passwordTxtField.resignFirstResponder()
            default:
                break
            }
        }
    }
}
