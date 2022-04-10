//
//  PrivacyViewController.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/31/22.
//

import UIKit
import WebKit

class PrivacyViewController: UIViewController {

    /// Outlets
    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadWebView()
    }
    
    fileprivate func loadWebView() {
        
    }
    
    @IBAction func cancelBtnTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
