//
//  PaymentViewController.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/7/22.
//

import UIKit
import Stripe

class PaymentViewController: UIViewController {
    
    /// Outlets - Input Fields
    @IBOutlet weak var paymentScrollView: UIScrollView!
    @IBOutlet weak var nameOnCardTxtField: UITextField!
    @IBOutlet weak var cardNumberTxtField: UITextField!
    @IBOutlet weak var expirationTxtField: UITextField!
    @IBOutlet weak var securityTxtField: UITextField!
    @IBOutlet weak var offerCodeTxtField: UITextField!
    @IBOutlet weak var collectCardDetailsBtn: UIButton!
    @IBOutlet weak var cardNumberStkView: UIStackView!
    @IBOutlet weak var cardNumberLbl: UILabel!
    @IBOutlet weak var offerAppliedLbl: UILabel!
    @IBOutlet weak var freshWeeklyFlowersLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var salesTaxLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /// Outlets - Segment Controls
    @IBOutlet weak var paymentOptionSegmentContrl: UISegmentedControl!
    
    var paymentSheet: PaymentSheet?
    let backendCheckoutUrl = URL(string: "https://stripe-mobile-payment-sheet.glitch.me/checkout")!
    
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
        self.offerAppliedLbl.isHidden = true
        self.paymentScrollView.keyboardDismissMode = .onDrag
        
        for segmentItem: UIView in self.paymentOptionSegmentContrl.subviews {
            for item : Any in segmentItem.subviews {
                if let i = item as? UILabel {
                    i.numberOfLines = 0
                    i.font = UIFont(name: "Avenir-Medium", size: 20.0)!
                }
            }
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
        
    }
    
    /// Online Payment Details Switch Changes
    @IBAction func onlinePaymentDetailsSwtichChanged(_ sender: UISwitch) {
        
    }
    
    /// Add Offer Code Button Touched
    @IBAction func addOfferCodeBtnTouched(_ sender: UIButton) {
        
    }
    
    /// Offer Apply Button Touched
    @IBAction func offerApplyBtnTouched(_ sender: UIButton) {
        
    }
    
    /// Privacy Button Touched
    @IBAction func privacyBtnTouched(_ sender: UIButton) {
        
    }
    
    /// Sign Me Up Button Touched
    @IBAction func signMeUpBtnTouched(_ sender: UIButton) {
        
    }
    
    /// Logout Button Touched
    @IBAction func logoutBtnTouched(_ sender: UIButton) {
        self.presentLogoutAlert()
    }
}
