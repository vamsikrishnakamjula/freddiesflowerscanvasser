//
//  SuperViewController.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 4/1/22.
//

import UIKit

class SuperViewController: UIViewController {

    /// Outlets - Input Fields
    @IBOutlet weak var yourDetailsBtn: UIButton!
    @IBOutlet weak var yourDetailsLbl: UILabel!
    @IBOutlet weak var deliveryBtn: UIButton!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var paymentDetailsBtn: UIButton!
    @IBOutlet weak var paymentDetailsLbl: UILabel!
    
    /// Outlets - Container Views
    @IBOutlet weak var yourDetailsContainverView: UIView!
    @IBOutlet weak var deliveryContainverView: UIView!
    @IBOutlet weak var paymentDetailsContainverView: UIView!
    
    /// Stored Properties
    var customerDetails: CustomerDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureUI()
    }
    
    fileprivate func configureUI() {
        /// Initially show your details container view
        self.setTopNavigationViews(yourDetails: true, delivery: false, paymentDetails: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDetailsSegue") {
            if let customerDetailsVC = segue.destination as? DetailsViewController {
                customerDetailsVC.delegate = self
            }
        } else if (segue.identifier == "toDeliverySegue") {
            if let deliveryVC = segue.destination as? DeliveryViewController {
                deliveryVC.delegate = self
            }
        } else if (segue.identifier == "toPaymentDetailsSegue") {
            if let paymentDetailsVC = segue.destination as? PaymentViewController {
                paymentDetailsVC.delegate = self
            }
        }
    }
    
    fileprivate func setTopNavigationViews(yourDetails: Bool, delivery: Bool, paymentDetails: Bool) {
        if (delivery) {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                self.yourDetailsLbl.font = UIFont(name: "Avenir Next Regular", size: 15.0)!
                self.deliveryLbl.font = UIFont(name: "Avenir Next Bold", size: 15.0)!
                self.paymentDetailsLbl.font = UIFont(name: "Avenir Next Regular", size: 15.0)!
            case .pad:
                self.yourDetailsLbl.font = UIFont(name: "Avenir Next Regular", size: 20.0)!
                self.deliveryLbl.font = UIFont(name: "Avenir Next Bold", size: 20.0)!
                self.paymentDetailsLbl.font = UIFont(name: "Avenir Next Regular", size: 20.0)!
            default:
                self.yourDetailsLbl.font = UIFont(name: "Avenir Next Regular", size: 15.0)!
                self.deliveryLbl.font = UIFont(name: "Avenir Next Bold", size: 15.0)!
                self.paymentDetailsLbl.font = UIFont(name: "Avenir Next Regular", size: 15.0)!
            }
            
            self.yourDetailsContainverView.isHidden = true
            self.deliveryContainverView.isHidden = false
            self.paymentDetailsContainverView.isHidden = true
            
            self.yourDetailsBtn.isEnabled = true
            self.deliveryBtn.isEnabled = false
            self.paymentDetailsBtn.isEnabled = false
        } else if (paymentDetails) {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                self.yourDetailsLbl.font = UIFont(name: "Avenir Next Regular", size: 15.0)!
                self.deliveryLbl.font = UIFont(name: "Avenir Next Regular", size: 15.0)!
                self.paymentDetailsLbl.font = UIFont(name: "Avenir Next Bold", size: 15.0)!
            case .pad:
                self.yourDetailsLbl.font = UIFont(name: "Avenir Next Regular", size: 20.0)!
                self.deliveryLbl.font = UIFont(name: "Avenir Next Regular", size: 20.0)!
                self.paymentDetailsLbl.font = UIFont(name: "Avenir Next Bold", size: 20.0)!
            default:
                self.yourDetailsLbl.font = UIFont(name: "Avenir Next Regular", size: 15.0)!
                self.deliveryLbl.font = UIFont(name: "Avenir Next Regular", size: 15.0)!
                self.paymentDetailsLbl.font = UIFont(name: "Avenir Next Bold", size: 15.0)!
            }
            
            self.yourDetailsContainverView.isHidden = true
            self.deliveryContainverView.isHidden = true
            self.paymentDetailsContainverView.isHidden = false
            
            self.yourDetailsBtn.isEnabled = true
            self.deliveryBtn.isEnabled = true
            self.paymentDetailsBtn.isEnabled = false
        } else {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                self.yourDetailsLbl.font = UIFont(name: "Avenir Next Bold", size: 15.0)!
                self.deliveryLbl.font = UIFont(name: "Avenir Next Regular", size: 15.0)!
                self.paymentDetailsLbl.font = UIFont(name: "Avenir Next Regular", size: 15.0)!
            case .pad:
                self.yourDetailsLbl.font = UIFont(name: "Avenir Next Bold", size: 20.0)!
                self.deliveryLbl.font = UIFont(name: "Avenir Next Regular", size: 20.0)!
                self.paymentDetailsLbl.font = UIFont(name: "Avenir Next Regular", size: 20.0)!
            default:
                self.yourDetailsLbl.font = UIFont(name: "Avenir Next Bold", size: 15.0)!
                self.deliveryLbl.font = UIFont(name: "Avenir Next Regular", size: 15.0)!
                self.paymentDetailsLbl.font = UIFont(name: "Avenir Next Regular", size: 15.0)!
            }
            
            self.yourDetailsContainverView.isHidden = false
            self.deliveryContainverView.isHidden = true
            self.paymentDetailsContainverView.isHidden = true
            
            self.yourDetailsBtn.isEnabled = true
            self.deliveryBtn.isEnabled = false
            self.paymentDetailsBtn.isEnabled = false
        }
    }
    
    /// Handle your details button
    @IBAction func yourDetailsBtnTouched(_ sender: UIButton) {
        self.setTopNavigationViews(yourDetails: true, delivery: false, paymentDetails: false)
    }
    
    @IBAction func deliveryBtnTouched(_ sender: UIButton) {
        self.setTopNavigationViews(yourDetails: false, delivery: true, paymentDetails: false)
    }
    
    @IBAction func paymentDetailsBtnTouched(_ sender: UIButton) {
        self.setTopNavigationViews(yourDetails: false, delivery: false, paymentDetails: true)
    }
    
    @IBAction func logoutBtnTouched(_ sender: UIButton) {
        self.presentLogoutAlert()
    }
}

extension SuperViewController: SuperViewDetailsDelegate {
    func updateCustomerDetails(details: CustomerDetails, yourDetails: Bool, delivery: Bool, paymentDetails: Bool) {
        self.customerDetails = details
        self.setTopNavigationViews(yourDetails: yourDetails, delivery: delivery, paymentDetails: paymentDetails)
    }
}
