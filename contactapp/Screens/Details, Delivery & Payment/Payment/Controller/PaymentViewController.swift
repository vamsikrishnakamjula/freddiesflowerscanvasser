//
//  PaymentViewController.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/7/22.
//

import UIKit
import Stripe
import ActionSheetPicker_3_0

class PaymentViewController: UIViewController {
    
    /// Outlets - Input Fields
    @IBOutlet weak var paymentScrollView: UIScrollView!
    @IBOutlet weak var nameOnCardTxtField: UITextField!
    @IBOutlet weak var cardNumberTxtField: UITextField!
    @IBOutlet weak var expirationTxtField: UITextField!
    @IBOutlet weak var securityTxtField: UITextField!
    @IBOutlet weak var zipCodeTxtField: UITextField!
    @IBOutlet weak var houseNumberTxtField: UITextField!
    @IBOutlet weak var firstLineAddressTxtField: UITextField!
    @IBOutlet weak var secondLineAddressTxtField: UITextField!
    @IBOutlet weak var townOrCityTxtField: UITextField!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var offerCodeTxtField: UITextField!
    @IBOutlet weak var collectCardDetailsBtn: UIButton!
    @IBOutlet weak var cardNumberStkView: UIStackView!
    @IBOutlet weak var cardNumberLbl: UILabel!
    @IBOutlet weak var offerAppliedLbl: UILabel!
    @IBOutlet weak var freshWeeklyFlowersLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var salesTaxLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var submitWarningLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /// Outlets - Switches
    @IBOutlet weak var cardReaderOptionsStkView: UIStackView!
    @IBOutlet weak var billingAddressSwitch: UISwitch!
    @IBOutlet weak var onlinePaymentSwitch: UISwitch!
    
    /// Outlets - Stack Views
    @IBOutlet weak var offerCodeStkView: UIStackView!
    @IBOutlet weak var paymentDetailsStkView: UIStackView!
    @IBOutlet weak var billingAddressStkView: UIStackView!
    
    /// Outlets - Segment Controls
    @IBOutlet weak var paymentOptionSegmentContrl: UISegmentedControl!
    
    /// Stored Properties
    var customerDetails: CustomerDetails?
    var countries: [String] = ["United States"]
    var paymentSheet: PaymentSheet?
    let backendCheckoutUrl = URL(string: "https://stripe-mobile-payment-sheet.glitch.me/checkout")!
    
    /// Delegate
    var delegate: SuperViewDetailsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectCardDetailsBtn.isEnabled = false

        // MARK: Fetch the PaymentIntent and Customer information from the backend
        var request = URLRequest(url: backendCheckoutUrl)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(
            with: request,
            completionHandler: { [weak self] (data, response, error) in
                guard let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                        as? [String: Any],
                    let customerId = json["customer"] as? String,
                    let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
                    let paymentIntentClientSecret = json["paymentIntent"] as? String,
                    let publishableKey = json["publishableKey"] as? String,
                    let self = self
                else {
                    // Handle error
                    return
                }
                // MARK: Set your Stripe publishable key - this allows the SDK to make requests to Stripe for your account
                STPAPIClient.shared.publishableKey = publishableKey

                // MARK: Create a PaymentSheet instance
                var configuration = PaymentSheet.Configuration()
                configuration.merchantDisplayName = "Example, Inc."
                configuration.applePay = .init(
                    merchantId: "com.foo.example", merchantCountryCode: "US")
                configuration.customer = .init(
                    id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
                configuration.returnURL = "payments-example://stripe-redirect"
                // Set allowsDelayedPaymentMethods to true if your business can handle payment methods that complete payment after a delay, like SEPA Debit and Sofort.
                configuration.allowsDelayedPaymentMethods = true
                self.paymentSheet = PaymentSheet(
                    paymentIntentClientSecret: paymentIntentClientSecret,
                    configuration: configuration)

                DispatchQueue.main.async {
                    self.collectCardDetailsBtn.isEnabled = true
                }
            })
        task.resume()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureUI()
    }
    
    fileprivate func configureUI() {
        self.hideKeyboardOnTap()
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        self.cardNumberLbl.isHidden = true
        self.billingAddressStkView.isHidden = true
        self.offerAppliedLbl.isHidden = true
        self.offerCodeStkView.isHidden = true
        
        self.paymentScrollView.setContentOffset(CGPoint.zero, animated: true)
        self.paymentScrollView.keyboardDismissMode = .onDrag
        
        for segmentItem: UIView in self.paymentOptionSegmentContrl.subviews {
            for item : Any in segmentItem.subviews {
                if let i = item as? UILabel {
                    i.numberOfLines = 0
                    i.font = UIFont(name: "Avenir-Medium", size: 20.0)!
                }
            }
        }
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            self.submitWarningLbl.highlight(text: "Terms and Conditions & Privacy Policy", font: UIFont(name: "Avenir-Medium", size: 15.0)!, color: UIColor.blue)
        case .pad:
            self.submitWarningLbl.highlight(text: "Terms and Conditions & Privacy Policy", font: UIFont(name: "Avenir-Medium", size: 20.0)!, color: UIColor.blue)
        default:
            self.submitWarningLbl.highlight(text: "Terms and Conditions & Privacy Policy", font: UIFont(name: "Avenir-Medium", size: 15.0)!, color: UIColor.blue)
        }
    }
    
    func displayAlert(_ message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// Reset Registration Button Touched
    @IBAction func resetRegistrationBtnTouched(_ sender: UIButton) {
        self.resetInputFields()
    }
    
    fileprivate func resetInputFields() {
        self.nameOnCardTxtField.text = ""
        self.cardNumberTxtField.text = ""
        self.cardNumberTxtField.placeholder = "---- ---- ---- ----"
        self.expirationTxtField.text = ""
        self.securityTxtField.text = ""
        self.billingAddressSwitch.isOn = true
        self.onlinePaymentSwitch.isOn = true
        self.freshWeeklyFlowersLbl.text = "$44"
        self.deliveryLbl.text = "Free"
        self.salesTaxLbl.text = "$TBC"
        self.totalLbl.text = "$44"
        self.offerCodeTxtField.text = ""
        self.offerCodeStkView.isHidden = true
        
        self.resetBillingAddressInputFields()
    }
    
    fileprivate func resetBillingAddressInputFields() {
        self.zipCodeTxtField.text = ""
        self.houseNumberTxtField.text = ""
        self.firstLineAddressTxtField.text = ""
        self.secondLineAddressTxtField.text = ""
        self.townOrCityTxtField.text = ""
        self.countryLbl.text = "Please select country"
        self.countryLbl.textColor = UIColor.lightGray
    }
    
    @IBAction func paymentOptionsSegmentCntrlChanged(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            self.cardReaderOptionsStkView.isHidden = false
        case 1:
            self.cardReaderOptionsStkView.isHidden = true
        default:
            self.cardReaderOptionsStkView.isHidden = false
        }
    }
    
    @IBAction func findAddressBtnTouched(_ sender: UIButton) {
        
    }
    
    @IBAction func countryBtnTouched(_ sender: UIButton) {
        ActionSheetStringPicker.show(withTitle: "Countries",
                                     rows: countries,
                                             initialSelection: 0,
                                             doneBlock: { picker, index, value in
                                            self.countryLbl.text = self.countries[index]
                                            self.countryLbl.textColor = UIColor.black
                                                return
                                             },
                                             cancel: { picker in
                                                return
                                             },
                                             origin: sender)
    }
    
    /// Discover Reader Button Touched
    @IBAction func discoverReaderBtnTouched(_ sender: UIButton) {
        
    }
    
    /// Collect Card Details Button Touched
    @IBAction func collectCardDetailsBtnTouched(_ sender: UIButton) {
        // MARK: Start the checkout process
        paymentSheet?.present(from: self) { paymentResult in
            // MARK: Handle the payment result
            switch paymentResult {
            case .completed:
                self.displayAlert("Your order is confirmed!")
            case .canceled:
                print("Canceled!")
            case .failed(let error):
                print(error)
                self.displayAlert("Payment failed: \n\(error.localizedDescription)")
            }
        }
    }
    
    /// Billing Address Switch Changes
    @IBAction func billingAddressSwitchChanged(_ sender: UISwitch) {
        if (sender.isOn) {
            self.billingAddressStkView.isHidden = true
        } else {
            self.billingAddressStkView.isHidden = false
        }
        self.resetBillingAddressInputFields()
    }
    
    /// Online Payment Details Switch Changes
    @IBAction func onlinePaymentDetailsSwtichChanged(_ sender: UISwitch) {
        if (sender.isOn) {
            self.paymentDetailsStkView.isHidden = true
        } else {
            self.paymentDetailsStkView.isHidden = false
        }
    }
    
    /// Add Offer Code Button Touched
    @IBAction func addOfferCodeBtnTouched(_ sender: UIButton) {
        if (sender.isSelected) {
            sender.isSelected = false
            self.offerCodeStkView.isHidden = true
        } else {
            sender.isSelected = true
            self.offerCodeStkView.isHidden = false
        }
    }
    
    /// Offer Apply Button Touched
    @IBAction func offerApplyBtnTouched(_ sender: UIButton) {
        if let offerCode = self.offerCodeTxtField.text, offerCode == "",
           let details = self.customerDetails, let deliveryDetails = details.delivery,
           let postalCode = deliveryDetails.deliveryAddressPostalCode, postalCode == "" {
            self.presentAlert(title: "Error!", message: "Please enter Offer code & Postal Code.")
        } else if let details = self.customerDetails, let deliveryDetails = details.delivery,
                  let postalCode = deliveryDetails.deliveryAddressPostalCode, postalCode == "" {
            self.checkOfferCode(postalCode: postalCode, offerCode: self.offerCodeTxtField.text ?? "")
        }
        self.checkOfferCode(postalCode: "93601", offerCode: self.offerCodeTxtField.text ?? "")
    }
    
    fileprivate func checkOfferCode(postalCode: String, offerCode: String) {
        DeliveryNetwork.shared.offerCode(postalCode: postalCode, friendCode: offerCode) { data, error in
            if (error != nil) {
                self.presentAlert(title: "Offer Code Error", message: error?.localizedDescription ?? "")
            } else if let responseData = data {
                self.updateOrderSummary(offerCodeResponse: responseData)
            }
        }
    }
    
    fileprivate func updateOrderSummary(offerCodeResponse: OfferCodeResponse) {
        if let price = offerCodeResponse.price, let discountedPrice = offerCodeResponse.discounted_price {
            self.freshWeeklyFlowersLbl.text = "$\(price) $\(price - discountedPrice)"
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                self.freshWeeklyFlowersLbl.highlight(text: "$\(price)", font: UIFont(name: "Avenir-Medium", size: 20.0)!, color: UIColor.red)
            case .pad:
                self.freshWeeklyFlowersLbl.highlight(text: "$\(price)", font: UIFont(name: "Avenir-Medium", size: 25.0)!, color: UIColor.red)
            default:
                self.freshWeeklyFlowersLbl.highlight(text: "$\(price)", font: UIFont(name: "Avenir-Medium", size: 20.0)!, color: UIColor.red)
            }
            self.totalLbl.text = "$\(price - discountedPrice)"
        }
        
        if let tax = offerCodeResponse.tax, let discountedTax = offerCodeResponse.discounted_tax {
            self.salesTaxLbl.text = "\(tax) \(tax - discountedTax)"
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                self.salesTaxLbl.highlight(text: "\(tax)", font: UIFont(name: "Avenir-Medium", size: 20.0)!, color: UIColor.red)
            case .pad:
                self.salesTaxLbl.highlight(text: "\(tax)", font: UIFont(name: "Avenir-Medium", size: 25.0)!, color: UIColor.red)
            default:
                self.salesTaxLbl.highlight(text: "\(tax)", font: UIFont(name: "Avenir-Medium", size: 20.0)!, color: UIColor.red)
            }
        }
        
        self.deliveryLbl.text = "Free"
    }
    
    /// Privacy Button Touched
    @IBAction func privacyBtnTouched(_ sender: UIButton) {
        self.presentPrivacyPolicyView()
    }
    
    /// Sign Me Up Button Touched
    @IBAction func signMeUpBtnTouched(_ sender: UIButton) {
        
    }
}
