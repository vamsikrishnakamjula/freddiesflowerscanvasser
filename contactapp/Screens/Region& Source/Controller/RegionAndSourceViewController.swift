//
//  RegionAndSourceViewController.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/7/22.
//

import UIKit

class RegionAndSourceViewController: UIViewController {

    /// Outlets - Input Fields
    @IBOutlet weak var regionLbl: UILabel!
    @IBOutlet weak var sourceLbl: UILabel!
    
    /// Stored Properties
    var regions = [String]()
    var sources = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationUI()
        self.hideKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchRegionsAndResouces()
    }
    
    fileprivate func fetchRegionsAndResouces() {
        /// Regions
        
        
        /// Sources
        
    }
    
    @IBAction func regionsBtnTouched(_ sender: UIButton) {
        
    }
    
    @IBAction func sourcesBtnTouched(_ sender: UIButton) {
        
    }
    
    ///  Next Step Button Touched
    @IBAction func nextStepBtnTouched(_ sender: UIButton) {
        
    }
}

extension RegionAndSourceViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return regions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return regions[row]
        }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
            self.regionLbl.text = regions[row]
            self.view.endEditing(true)
        }

}
