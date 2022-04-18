//
//  SetPasswordViewController.swift
//  Crows
//
//  Created by Yingwei Fan on 4/25/21.
//

import UIKit
import MBProgressHUD

private let StackViewDefaultSpacing: CGFloat = 8.0
private let TextFieldHeight: CGFloat = 40.0
private let ConfirmButtonHeight: CGFloat = 40.0

class SetPasswordViewController: UIViewController {

  private let titleLabel = UILabel()

  private let usernameLabel = UILabel()

  private let usernameTextField = RoundTextField()

  private let passwordLabel = UILabel()

  private let passwordTextField = RoundTextField()

  private let confirmPasswordLabel = UILabel()

  private let confirmPasswordTextField = RoundTextField()

  private let confirmButton = AnimationButton()

  private let stackView = UIStackView()

  private let emailAddress: String

  init(emailAddress: String) {
    self.emailAddress = emailAddress

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = CrowsColor.white
//    navigationItem.setHidesBackButton(true, animated: false)
    configureSubviews()
    configureConstraints()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    usernameTextField.becomeFirstResponder()
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
      confirmButton.layer.borderColor = CrowsColor.grey800.cgColor
    }
  }

  // MARK: - Private

  private func configureSubviews() {
    stackView.axis = .vertical
    stackView.spacing = StackViewDefaultSpacing
    view.addSubview(stackView)

      // TODO: Update this part when the sign up flow is changed.
//    titleLabel.font = CrowsFont.pageTitle
//    titleLabel.textColor = CrowsColor.grey900
//    titleLabel.textAlignment = .center
//    titleLabel.text = NSLocalizedString("SignIn.SetPasswordTitle", comment: "")
//    stackView.addArrangedSubview(titleLabel)
//    stackView.setCustomSpacing(VerticalPadding.standard.rawValue, after: titleLabel)
    usernameLabel.font = CrowsFont.text
    usernameLabel.textColor = CrowsColor.grey900
    usernameLabel.text = NSLocalizedString("SignIn.Username", comment: "")
    stackView.addArrangedSubview(usernameLabel)

    usernameTextField.autocorrectionType = .no
    usernameTextField.autocapitalizationType = .none
    stackView.addArrangedSubview(usernameTextField)
    stackView.setCustomSpacing(VerticalPadding.standard.rawValue, after: usernameTextField)

    passwordLabel.font = CrowsFont.text
    passwordLabel.textColor = CrowsColor.grey900
    passwordLabel.text = NSLocalizedString("SignIn.Password", comment: "")
    stackView.addArrangedSubview(passwordLabel)

    passwordTextField.isSecureTextEntry = true
    passwordTextField.clearButtonMode = .whileEditing
    stackView.addArrangedSubview(passwordTextField)
    stackView.setCustomSpacing(VerticalPadding.standard.rawValue, after: passwordTextField)

    confirmPasswordLabel.font = CrowsFont.text
    confirmPasswordLabel.text = NSLocalizedString("SignIn.ConfirmPassword", comment: "")
    stackView.addArrangedSubview(confirmPasswordLabel)

    confirmPasswordTextField.isSecureTextEntry = true
    confirmPasswordTextField.clearButtonMode = .whileEditing
    stackView.addArrangedSubview(confirmPasswordTextField)
    stackView.setCustomSpacing(VerticalPadding.standard.rawValue * 2, after: confirmPasswordTextField)

    confirmButton.layer.cornerRadius = CornerRadius.small.rawValue
    confirmButton.layer.masksToBounds = true
    confirmButton.layer.borderWidth = 2.0
    confirmButton.layer.borderColor = CrowsColor.grey800.cgColor
    confirmButton.setTitle(NSLocalizedString("Confirm", comment: ""), for: .normal)
    confirmButton.setTitleColor(CrowsColor.grey900, for: .normal)
    confirmButton.titleLabel?.font = CrowsFont.buttonBig
    confirmButton.addTarget(self, action: #selector(didTapConfirm(_:)), for: .touchUpInside)
    stackView.addArrangedSubview(confirmButton)
  }

  private func configureConstraints() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    passwordTextField.translatesAutoresizingMaskIntoConstraints = false
    confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false

    let safeAreaLayoutGuide = view.safeAreaLayoutGuide
    let marginsGuide = view.layoutMarginsGuide
    let constraints = [
      stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor),

      usernameTextField.heightAnchor.constraint(equalToConstant: TextFieldHeight),
      passwordTextField.heightAnchor.constraint(equalToConstant: TextFieldHeight),
      confirmPasswordTextField.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor),

      confirmButton.heightAnchor.constraint(equalToConstant: ConfirmButtonHeight)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - Private

  @objc private func didTapConfirm(_ button: UIButton) {
    guard let username = usernameTextField.text, !username.isEmpty else {
      usernameTextField.shake {
        self.usernameTextField.becomeFirstResponder()
      }
      return
    }
    guard let password = passwordTextField.text, !password.isEmpty else {
      passwordTextField.shake {
        self.passwordTextField.becomeFirstResponder()
      }
      return
    }
    guard let passwordConfirm = confirmPasswordTextField.text, !passwordConfirm.isEmpty else {
      confirmPasswordTextField.shake {
        self.confirmPasswordTextField.becomeFirstResponder()
      }
      return
    }
    guard password == passwordConfirm else {
      return
    }
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    CrowsServices.shared.registerNewUser(username: username, email: emailAddress, password: password) { success, error in
      guard success else {
        var delay: TimeInterval = 0
        if let error = error {
          hud.mode = .text
          hud.label.numberOfLines = 0
          hud.label.text = error.localizedDescription
          delay = 1.5
        }
        hud.hide(animated: true, afterDelay: delay)
        return
      }
      hud.hide(animated: true)
      let hobbySelectionViewController = HobbySelectionViewController()
      self.navigationController?.pushViewController(hobbySelectionViewController, animated: true)
    }
  }

}
