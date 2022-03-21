//
//  LoginViewController.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/7/22.
//

import UIKit

class LoginViewController: UIViewController, UIScrollViewDelegate {
    
    /// Outlets - Input Fields
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationUI()
        self.hideKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailTxtField.text = "canvasser@ff.us"
        self.passwordTxtField.text = "canvasser@ff.us"
    }
    
    /// Login Button Touched
    @IBAction func loginBtnTouched(_ sender: UIButton) {
        let errorMessage = self.validateCredentials()
        if (errorMessage != "") {
            self.presentAlert(title: "Invalid Credentials!", message: errorMessage)
        } else {
            if let email = self.emailTxtField.text,
               let password = self.passwordTxtField.text {
                LoginNetwork.shared.login(email: email, password: password) { response, error in
                    if (error != nil) {
                        self.presentAlert(title: "Something went wrong", message: error?.localizedDescription ?? "")
                    } else if let loginResponse = response {
                        LoginViewModel.shared.cacheRefreshToken(login: loginResponse)
                        self.performSegue(withIdentifier: "toRegionsAndSourceSegue", sender: nil)
                    }
                }
            }
        }
    }
    
    
    /// Discover Reader Button Touched
    @IBAction func discoverReaderBtnTouched(_ sender: UIButton) {
        
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
    
    fileprivate func validateCredentials() -> String {
        if let email = self.emailTxtField.text {
            if (email == "" || !self.isValidEmail(email: email)) {
                return "Please enter valid email."
            }
        }
        
        if let password = self.passwordTxtField.text, password == "" {
            return "Please enter password."
        }
        
        return ""
    }
}
