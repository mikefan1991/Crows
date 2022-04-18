//
//  SignupViewController.swift
//  Crows
//
//  Created by Yingwei Fan on 4/24/21.
//

import UIKit
import MBProgressHUD

private let TextFieldHeight: CGFloat = 40.0
private let GetCodeButtonHeight: CGFloat = 40.0

class SignupViewController: UIViewController {

  private let titleLabel = UILabel()

  private let emailAddressLabel = UILabel()

  private let emailAddressTextField = RoundTextField()

  private let agreementLabel = UITextView()

  private let getCodeButton = AnimationButton()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = CrowsColor.white
    configureSubviews()
    configureConstraints()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    emailAddressTextField.becomeFirstResponder()
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
      getCodeButton.layer.borderColor = CrowsColor.grey800.cgColor
    }
  }

  // MARK: - Private

  private func configureSubviews() {
    titleLabel.font = CrowsFont.pageTitle
    titleLabel.textColor = CrowsColor.grey900
    titleLabel.textAlignment = .center
    titleLabel.text = NSLocalizedString("SignIn.Signup", comment: "")
    view.addSubview(titleLabel)

    emailAddressLabel.font = CrowsFont.text
    emailAddressLabel.textColor = CrowsColor.grey900
    emailAddressLabel.text = NSLocalizedString("SignIn.EmailAddress", comment: "")
    view.addSubview(emailAddressLabel)

    emailAddressTextField.keyboardType = .emailAddress
    emailAddressTextField.textContentType = .emailAddress
    emailAddressTextField.autocorrectionType = .no
    emailAddressTextField.autocapitalizationType = .none
    view.addSubview(emailAddressTextField)

    agreementLabel.backgroundColor = .clear
    agreementLabel.tintColor = CrowsColor.blue
    agreementLabel.isScrollEnabled = false
    let termsOfService = NSLocalizedString("SignIn.TermsOfService", comment: "")
    let privacyPolicy = NSLocalizedString("SignIn.PrivacyPolicy", comment: "")
    let agreement = NSLocalizedString("SignIn.Agreement", comment: "")
    let rangeOfAgreement = NSRange(location: 0, length: agreement.count)
    let rangeOfTerms = NSRange(agreement.range(of: termsOfService)!, in: agreement)
    let rangeOfPrivacy = NSRange(agreement.range(of: privacyPolicy)!, in: agreement)
    let attributedAgreement = NSMutableAttributedString(string: agreement)
    attributedAgreement.addAttribute(.link, value: "https://policies.google.com/terms", range: rangeOfTerms)
    attributedAgreement.addAttribute(.link, value: "https://policies.google.com/privacy", range: rangeOfPrivacy)
    attributedAgreement.addAttribute(.foregroundColor, value: CrowsColor.grey900, range: rangeOfAgreement)
    attributedAgreement.addAttribute(.font, value: CrowsFont.caption, range: rangeOfAgreement)
    agreementLabel.attributedText = attributedAgreement
    view.addSubview(agreementLabel)

    getCodeButton.layer.cornerRadius = CornerRadius.small.rawValue
    getCodeButton.layer.masksToBounds = true
    getCodeButton.layer.borderWidth = 2.0
    getCodeButton.layer.borderColor = CrowsColor.grey800.cgColor
    getCodeButton.setTitle(NSLocalizedString("Next", comment: ""), for: .normal)
    getCodeButton.setTitleColor(CrowsColor.grey900, for: .normal)
    getCodeButton.titleLabel?.font = CrowsFont.buttonBig
    getCodeButton.addTarget(self, action: #selector(didTapGetCode(_:)), for: .touchUpInside)
    view.addSubview(getCodeButton)
  }

  private func configureConstraints() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    emailAddressLabel.translatesAutoresizingMaskIntoConstraints = false
    emailAddressTextField.translatesAutoresizingMaskIntoConstraints = false
    agreementLabel.translatesAutoresizingMaskIntoConstraints = false
    getCodeButton.translatesAutoresizingMaskIntoConstraints = false

    let safeAreaLayoutGuide = view.safeAreaLayoutGuide
    let marginsGuide = view.layoutMarginsGuide
    let constraints = [
      titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor),

      emailAddressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: VerticalPadding.standard.rawValue * 2),
      emailAddressLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      emailAddressLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

      emailAddressTextField.topAnchor.constraint(equalTo: emailAddressLabel.bottomAnchor, constant: VerticalPadding.small.rawValue),
      emailAddressTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      emailAddressTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      emailAddressTextField.heightAnchor.constraint(equalToConstant: TextFieldHeight),

      agreementLabel.topAnchor.constraint(equalTo: emailAddressTextField.bottomAnchor, constant: VerticalPadding.standard.rawValue * 2),
      agreementLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: HorizontalPadding.standard.rawValue),
      agreementLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -HorizontalPadding.standard.rawValue),

      getCodeButton.topAnchor.constraint(equalTo: agreementLabel.bottomAnchor, constant: VerticalPadding.medium.rawValue),
      getCodeButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      getCodeButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      getCodeButton.heightAnchor.constraint(equalToConstant: GetCodeButtonHeight)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - Actions

  @objc private func didTapGetCode(_ button: UIButton) {
    guard let emailAddress = emailAddressTextField.text, !emailAddress.isEmpty else {
      emailAddressTextField.shake()
      return
    }
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    hud.label.numberOfLines = 0
    guard emailAddress.isValidEmail else {
      hud.mode = .text
      hud.label.text = NSLocalizedString("", comment: "")
      hud.hide(animated: true, afterDelay: 1.5)
      return
    }
    CrowsServices.shared.checkRegisterEmailConflict(email: emailAddress) { success, error in
      guard success else {
        hud.mode = .text
        if let error = error  {
          hud.label.text = error.localizedDescription
        }
        hud.hide(animated: true, afterDelay: 1.5)
        return
      }
      hud.hide(animated: true)
      let setPasswordViewController = SetPasswordViewController(emailAddress: emailAddress)
      self.navigationController?.pushViewController(setPasswordViewController, animated: true)
    }
  }

}
