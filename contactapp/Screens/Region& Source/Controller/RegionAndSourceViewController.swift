//
//  RegionAndSourceViewController.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/7/22.
//

import UIKit
import ActionSheetPicker_3_0

class RegionAndSourceViewController: UIViewController {

    /// Outlets - Input Fields
    @IBOutlet weak var regionLbl: UILabel!
    @IBOutlet weak var sourceLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /// Stored Properties
    var regions = [String]()
    var sources = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationUI()
        self.hideKeyboardOnTap()
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        self.fetchRegionsAndResouces()
    }
    
    fileprivate func fetchRegionsAndResouces() {
        /// Regions
        RegionAndSourceNetwork.shared.getRegions { data, error in
            if (error != nil) {
                self.presentAlert(title: "Regions Error", message: error?.localizedDescription ?? "")
            } else if let responseData = data {
                if let regionsData = responseData.data {
                    regionsData.forEach{ self.regions.append($0.name ?? "") }
                }
            }
        }
        
        
        /// Sources
        RegionAndSourceNetwork.shared.getSources { data, error in
            if (error != nil) {
                self.presentAlert(title: "Sources Error", message: error?.localizedDescription ?? "")
            } else if let responseData = data {
                if let sourcesData = responseData.data {
                    sourcesData.forEach{ self.sources.append($0.name ?? "") }
                }
            }
        }
    }
    
    @IBAction func regionsBtnTouched(_ sender: UIButton) {
        ActionSheetStringPicker.show(withTitle: "Regions",
                                     rows: regions,
                                             initialSelection: 0,
                                             doneBlock: { picker, index, value in
                                            self.regionLbl.text = self.regions[index]
                                            self.regionLbl.textColor = UIColor.black
                                                return
                                             },
                                             cancel: { picker in
                                                return
                                             },
                                             origin: sender)
    }
    
    @IBAction func sourcesBtnTouched(_ sender: UIButton) {
        ActionSheetStringPicker.show(withTitle: "Sources",
                                     rows: sources,
                                             initialSelection: 0,
                                             doneBlock: { picker, index, value in
                                            self.sourceLbl.text = self.sources[index]
                                            self.sourceLbl.textColor = UIColor.black
                                                return
                                             },
                                             cancel: { picker in
                                                return
                                             },
                                             origin: sender)
    }
    
    ///  Next Step Button Touched
    @IBAction func nextStepBtnTouched(_ sender: UIButton) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        sender.isEnabled = false
        let errorMessage = self.validateSelections()
        if (errorMessage != "") {
            self.presentAlert(title: "Error!", message: errorMessage)
            sender.isEnabled = true
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        } else {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "toSignUpSegue", sender: nil)
        }
    }
    
    @IBAction func logoutBtnTouched(_ sender: UIBarButtonItem) {
        self.presentLogoutAlert()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toSignUpSegue") {
            if let signUpVC = segue.destination as? DetailsViewController {
                signUpVC.region = self.regionLbl.text ?? ""
                signUpVC.source = self.sourceLbl.text ?? ""
            }
        }
    }
    
    fileprivate func validateSelections() -> String {
        if let region = self.regionLbl.text, region == "Please select an area" {
            return "Please select a Region."
        }
        
        if let source = self.sourceLbl.text, source == "Please select a channel" {
            return "Please select a Source."
        }
        
        return ""
    }
}
