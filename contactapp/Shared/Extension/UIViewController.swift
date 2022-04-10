//
//  UIViewController.swift
//  contactapp
//
//  Created by Vamsi Kamjula on 3/11/22.
//

import UIKit

private let imageView = UIImageView(image: UIImage(named: "logo"))

extension UIViewController {
    
    func hideKeyboardOnTap() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tapGes.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGes)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
                    "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
        "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
                    "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
        "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentPrivacyPolicyView() {
        let storyboard = UIStoryboard(name: "Privacy", bundle: nil)
        if let privacyVC = storyboard.instantiateInitialViewController() as? PrivacyViewController {
            self.present(privacyVC, animated: true, completion: nil)
        }
    }
    
    func presentLogoutAlert() {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure want to Login?", preferredStyle: UIAlertController.Style.alert)
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { action in
            self.presentLogin()
        }
        let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentLogin() {
        performSegue(withIdentifier: "toLogoutSegue", sender: self)
    }
    
    public struct Const {
        static let ImageSizeForLargeState: CGFloat = 75
        static let ImageLeftMargin: CGFloat = 16
        static let ImageBottomMarginForLargeState: CGFloat = 12
        static let ImageBottomMarginForSmallState: CGFloat = 6
        static let ImageSizeForSmallState: CGFloat = 32
        static let NavBarHeightSmallState: CGFloat = 44
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
    
    public func setupNavigationUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: navigationBar.leftAnchor, constant: Const.ImageLeftMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalToConstant: 100)
            ])
        self.showImage(true)
    }
    
    public func showImage(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            imageView.alpha = show ? 1.0 : 0.0
        }
    }
}
