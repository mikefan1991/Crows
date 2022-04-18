//
//  ForgetPasswordViewController.swift
//  Crows
//
//  Created by Yingwei Fan on 5/28/21.
//

import UIKit
import MBProgressHUD

private let TextFieldHeight: CGFloat = 40.0
private let RecoverButtonHeight: CGFloat = 40.0

class ForgetPasswordViewController: UIViewController {

  private let stackView = UIStackView()

  private let descriptionLabel = UILabel()

  private let emailTextField = RoundTextField()

  private let recoverButton = AnimationButton()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = CrowsColor.white
    configureSubviews()
    configureConstraints()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    emailTextField.becomeFirstResponder()
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
      recoverButton.layer.borderColor = CrowsColor.grey800.cgColor
    }
  }

  // MARK: - Private

  private func configureSubviews() {
    stackView.axis = .vertical
    stackView.spacing = VerticalPadding.standard.rawValue
    view.addSubview(stackView)

    descriptionLabel.font = CrowsFont.text
    descriptionLabel.textColor = CrowsColor.grey900
    descriptionLabel.numberOfLines = 0
    descriptionLabel.text = NSLocalizedString("SignIn.ForgetPasswordDescription", comment: "")
    stackView.addArrangedSubview(descriptionLabel)

    emailTextField.autocorrectionType = .no
    emailTextField.autocapitalizationType = .none
    emailTextField.keyboardType = .emailAddress
    stackView.addArrangedSubview(emailTextField)

    recoverButton.layer.cornerRadius = CornerRadius.small.rawValue
    recoverButton.layer.masksToBounds = true
    recoverButton.layer.borderWidth = 2.0
    recoverButton.layer.borderColor = CrowsColor.grey800.cgColor
    recoverButton.setTitle(NSLocalizedString("SignIn.RecoverPassword", comment: ""), for: .normal)
    recoverButton.setTitleColor(CrowsColor.grey900, for: .normal)
    recoverButton.titleLabel?.font = CrowsFont.buttonBig
    recoverButton.addTarget(self, action: #selector(didTapRecover(_:)), for: .touchUpInside)
    stackView.addArrangedSubview(recoverButton)
  }

  private func configureConstraints() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    emailTextField.translatesAutoresizingMaskIntoConstraints = false
    recoverButton.translatesAutoresizingMaskIntoConstraints = false

    let marginsGuide = view.layoutMarginsGuide
    let constraints = [
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: VerticalPadding.standard.rawValue),
      stackView.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor),

      emailTextField.heightAnchor.constraint(equalToConstant: TextFieldHeight),
      recoverButton.heightAnchor.constraint(equalToConstant: RecoverButtonHeight)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - Actions

  @objc private func didTapRecover(_ button: UIButton) {
    guard let email = emailTextField.text, !email.isEmpty else {
      emailTextField.shake()
      return
    }
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    hud.label.numberOfLines = 0
    CrowsServices.shared.recoverPassword(email: email) { success, error in
      hud.mode = .text
      guard success else {
        if let error = error {
          hud.label.text = error.localizedDescription
        }
        hud.hide(animated: true, afterDelay: 1.5)
        return
      }
      hud.label.text = NSLocalizedString("SignIn.RecoverEmailSent", comment: "")
      hud.hide(animated: true, afterDelay: 1.5)
    }
  }

}
