//
//  ApplePayHeaderView.swift
//  StripeiOS
//
//  Created by Yuki Tokuhiro on 11/9/20.
//  Copyright © 2020 Stripe, Inc. All rights reserved.
//

import Foundation
import PassKit
import UIKit

@_spi(STP) import StripeUICore

protocol WalletHeaderViewDelegate: AnyObject {
    func walletHeaderViewApplePayButtonTapped(
        _ header: PaymentSheetViewController.WalletHeaderView
    )

    func walletHeaderViewPayWithLinkTapped(
        _ header: PaymentSheetViewController.WalletHeaderView
    )
}

extension PaymentSheetViewController {
    /// A view that looks like:
    ///
    /// [Apple Pay button]
    /// [Link button]
    ///  --- or pay with ---
    ///
    final class WalletHeaderView: UIView {
        struct Constants {
            /// Space between buttons
            static let buttonSpacing: CGFloat = 8
            /// Space between the separator label and the last button
            static let labelSpacing: CGFloat = 24
            /// Height for the Apple Pay button
            static let applePayButtonHeight: CGFloat = 44
        }

        struct WalletOptions: OptionSet {
            let rawValue: Int

            static let applePay = WalletOptions(rawValue: 1 << 0)
            static let link = WalletOptions(rawValue: 1 << 1)
        }

        weak var delegate: WalletHeaderViewDelegate?

        var linkAccount: PaymentSheetLinkAccountInfoProtocol? {
            didSet {
                if supportsPayWithLink {
                    payWithLinkButton.linkAccount = linkAccount
                }
            }
        }

        var showsCardPaymentMessage: Bool = false {
            didSet {
                updateSeparatorLabel()
            }
        }

        private let options: WalletOptions

        private lazy var applePayButton: PKPaymentButton = {
            let button = PKPaymentButton(paymentButtonType: .plain, paymentButtonStyle: .compatibleAutomatic)
            button.addTarget(self, action: #selector(handleTapApplePay), for: .touchUpInside)

            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: Constants.applePayButtonHeight)
            ])

            if #available(iOS 12.0, *) {
                button.cornerRadius = ElementsUI.defaultCornerRadius
            }

            return button
        }()
        
        private lazy var payWithLinkButton: PayWithLinkButton = {
            let button = PayWithLinkButton()
            button.addTarget(self, action: #selector(handleTapPayWithLink), for: .touchUpInside)
            return button
        }()

        private lazy var separatorLabel = SeparatorLabel()

        private var supportsApplePay: Bool {
            return options.contains(.applePay)
        }

        private var supportsPayWithLink: Bool {
            return options.contains(.link)
        }

        init(options: WalletOptions, delegate: WalletHeaderViewDelegate?) {
            self.options = options
            self.delegate = delegate
            super.init(frame: .zero)

            var buttons: [UIView] = []

            if supportsApplePay {
                buttons.append(applePayButton)
            }

            if supportsPayWithLink {
                buttons.append(payWithLinkButton)
            }

            let stackView = UIStackView(arrangedSubviews: buttons + [separatorLabel])
            stackView.axis = .vertical
            stackView.spacing = Constants.buttonSpacing

            if let lastButton = buttons.last {
                stackView.setCustomSpacing(Constants.labelSpacing, after: lastButton)
            }

            addAndPinSubview(stackView)

            updateSeparatorLabel()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc func handleTapApplePay() {
            delegate?.walletHeaderViewApplePayButtonTapped(self)
        }
        
        @objc func handleTapPayWithLink() {
            delegate?.walletHeaderViewPayWithLinkTapped(self)
        }

        private func updateSeparatorLabel() {
            if showsCardPaymentMessage {
                separatorLabel.text = STPLocalizedString(
                    "Or pay with a card",
                    "Title of a section displayed below an Apple Pay button. The section contains a credit card form as an alternative way to pay."
                )
            } else {
                separatorLabel.text = STPLocalizedString(
                    "Or pay using",
                    "Title of a section displayed below an Apple Pay button. The section contains alternative ways to pay."
                )
            }
        }
    }
}
