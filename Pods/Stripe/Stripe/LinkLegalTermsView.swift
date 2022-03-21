//
//  LinkLegalTermsView.swift
//  StripeiOS
//
//  Created by Ramon Torres on 1/26/22.
//  Copyright © 2022 Stripe, Inc. All rights reserved.
//

import UIKit
@_spi(STP) import StripeUICore

protocol LinkLegalTermsViewDelegate: AnyObject {
    /// Called when the user taps on a legal link.
    ///
    /// Implementation must return `true` if the link was handled. Returning `false`results in the link
    /// to open in the default browser.
    ///
    /// - Parameters:
    ///   - legalTermsView: The view that the user interacted with.
    ///   - url: URL of the link.
    /// - Returns: `true` if the link was handled by the delegate.
    func legalTermsView(_ legalTermsView: LinkLegalTermsView, didTapOnLinkWithURL url: URL) -> Bool
}

/// For internal SDK use only
@objc(STP_Internal_LinkLegalTermsView)
final class LinkLegalTermsView: UIView {

    // TODO(ramont): Update with final URLs
    private let links: [String: URL] = [
        "terms": URL(string: "https://stripe.com/legal")!,
        "privacy": URL(string: "https://stripe.com/privacy-center/legal#stripe-checkout")!
    ]

    weak var delegate: LinkLegalTermsViewDelegate?

    var textColor: UIColor? {
        get {
            return textView.textColor
        }
        set {
            textView.textColor = newValue
        }
    }

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = LinkUI.font(forTextStyle: .caption)
        textView.backgroundColor = .clear
        textView.attributedText = formattedLegalText()
        textView.textColor = CompatibleColor.secondaryLabel
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.delegate = self
        textView.clipsToBounds = false
        return textView
    }()

    init(textAlignment: NSTextAlignment = .left, delegate: LinkLegalTermsViewDelegate? = nil) {
        super.init(frame: .zero)
        self.textView.textAlignment = textAlignment
        self.delegate = delegate
        addAndPinSubview(textView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        textView.font = LinkUI.font(forTextStyle: .caption, compatibleWith: traitCollection)
    }

    private func formattedLegalText() -> NSAttributedString {
        let string = STPLocalizedString(
            "By joining Link, you agree to the <terms>Terms</terms> and <privacy>Privacy Policy</privacy>.",
            "Legal text shown when creating a Link account."
        )

        let formattedString = NSMutableAttributedString()

        STPStringUtils.parseRanges(from: string, withTags: Set<String>(links.keys)) { string, matches in
            formattedString.append(NSAttributedString(string: string))

            for (tag, range) in matches {
                guard range.rangeValue.location != NSNotFound else {
                    assertionFailure("Tag '<\(tag)>' not found")
                    continue
                }

                if let url = links[tag] {
                    formattedString.addAttributes([.link: url], range: range.rangeValue)
                }
            }
        }

        let paragraphStyle = NSMutableParagraphStyle()
        // TODO(ramont): Implement line spacing calculation
        paragraphStyle.lineSpacing = 6

        formattedString.addAttributes([.paragraphStyle: paragraphStyle], range: formattedString.extent)

        return formattedString
    }

}

extension LinkLegalTermsView: UITextViewDelegate {

    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        guard interaction == .invokeDefaultAction else {
            // Disable preview and actions
            return false
        }

        let handled = delegate?.legalTermsView(self, didTapOnLinkWithURL: URL) ?? false
        assert(handled, "Link not handled by delegate")

        // If not handled by the delegate, let the system handle the link.
        return !handled
    }

}
