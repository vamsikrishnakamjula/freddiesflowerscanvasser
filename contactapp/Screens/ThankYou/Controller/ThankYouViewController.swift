//
//  ThankYouViewController.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/7/22.
//

import UIKit

class ThankYouViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /// Finished Button Touched
    @IBAction func finishedBtnTouched(_ sender: UIButton) {
        
    }
    
    /// Logout Button Touched
    @IBAction func logoutBtnTouched(_ sender: UIButton) {
        self.presentLogoutAlert()
    }
}
