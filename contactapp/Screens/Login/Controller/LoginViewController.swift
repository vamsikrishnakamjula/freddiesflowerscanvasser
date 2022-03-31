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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationUI()
        self.hideKeyboardOnTap()
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        self.emailTxtField.text = "canvasser@ff.us"
        self.passwordTxtField.text = "canvasser@ff.us"
    }
    
    /// Login Button Touched
    @IBAction func loginBtnTouched(_ sender: UIButton) {
        sender.isEnabled = false
        let errorMessage = self.validateCredentials()
        if (errorMessage != "") {
            self.presentAlert(title: "Invalid Credentials!", message: errorMessage)
            sender.isEnabled = true
        } else {
            if let email = self.emailTxtField.text,
               let password = self.passwordTxtField.text {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                LoginNetwork.shared.login(email: email, password: password) { response, error in
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    if (error != nil) {
                        self.presentAlert(title: "Something went wrong", message: error?.localizedDescription ?? "")
                    } else if let loginResponse = response {
                        LoginViewModel.shared.cacheRefreshToken(login: loginResponse)
                        self.performSegue(withIdentifier: "toRegionsAndSourceSegue", sender: nil)
                    }
                }
                sender.isEnabled = true
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
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {}
}
