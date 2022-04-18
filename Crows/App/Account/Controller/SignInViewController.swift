//
//  SignInViewController.swift
//  Crows
//
//  Created by Yingwei Fan on 3/31/21.
//

import UIKit
import MBProgressHUD

private let TextFieldHeight: CGFloat = 40.0
private let LoginButtonHeight: CGFloat = 40.0

protocol SignInViewControllerDelegate: NSObjectProtocol {
  func signInViewController(_ viewController: SignInViewController, didLogin result: Bool, _ error: NSError?)
}

class SignInViewController: UIViewController {

  private let welcomeLabel = UILabel()

  private let emailLabel = UILabel()

  private let emailTextField = RoundTextField()

  private let passwordLabel = UILabel()

  private let passwordTextField = RoundTextField()

  private let forgetPasswordButton = UIButton()

  private let signupButton = UIButton()

  private let loginButton = AnimationButton()

  weak var delegate: SignInViewControllerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = CrowsColor.white
    configureSubviews()
    configureConstraints()
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
      loginButton.layer.borderColor = CrowsColor.grey800.cgColor
    }
  }

  // MARK: - Private

  private func configureSubviews() {
    welcomeLabel.font = CrowsFont.pageTitle
    welcomeLabel.textAlignment = .center
    welcomeLabel.textColor = CrowsColor.grey900
    welcomeLabel.text = NSLocalizedString("SignIn.Welcome", comment: "")
    view.addSubview(welcomeLabel)

    emailLabel.font = CrowsFont.text
    emailLabel.textColor = CrowsColor.grey900
    emailLabel.text = NSLocalizedString("SignIn.EmailAddress", comment: "")
    view.addSubview(emailLabel)

    emailTextField.keyboardType = .emailAddress
    emailTextField.textContentType = .emailAddress
    emailTextField.autocorrectionType = .no
    emailTextField.autocapitalizationType = .none
    view.addSubview(emailTextField)

    passwordLabel.font = CrowsFont.text
    passwordLabel.textColor = CrowsColor.grey900
    passwordLabel.text = NSLocalizedString("SignIn.Password", comment: "")
    view.addSubview(passwordLabel)

    passwordTextField.isSecureTextEntry = true
    view.addSubview(passwordTextField)

    let attributes: [NSAttributedString.Key: Any] = [
      NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
      NSAttributedString.Key.font: CrowsFont.caption,
      NSAttributedString.Key.foregroundColor: CrowsColor.grey900
    ]
    let forgetPasswordTitle = NSLocalizedString("SignIn.ForgetPassword", comment: "")
    let attributedForgetPasswordTitle = NSAttributedString(string: forgetPasswordTitle, attributes: attributes)
    forgetPasswordButton.setAttributedTitle(attributedForgetPasswordTitle, for: .normal)
    forgetPasswordButton.addTarget(self, action: #selector(didTapForgetPassword(_:)), for: .touchUpInside)
    view.addSubview(forgetPasswordButton)

    let signupTitle = NSLocalizedString("SignIn.Signup", comment: "")
    let attributedSignupTitle = NSAttributedString(string: signupTitle, attributes: attributes)
    signupButton.setAttributedTitle(attributedSignupTitle, for: .normal)
    signupButton.addTarget(self, action: #selector(didTapSignup(_:)), for: .touchUpInside)
    view.addSubview(signupButton)

    loginButton.layer.cornerRadius = CornerRadius.small.rawValue
    loginButton.layer.masksToBounds = true
    loginButton.layer.borderWidth = 2.0
    loginButton.layer.borderColor = CrowsColor.grey800.cgColor
    loginButton.setTitle(NSLocalizedString("SignIn.Login", comment: ""), for: .normal)
    loginButton.setTitleColor(CrowsColor.grey900, for: .normal)
    loginButton.titleLabel?.font = CrowsFont.buttonBig
    loginButton.addTarget(self, action: #selector(didTapLogin(_:)), for: .touchUpInside)
    view.addSubview(loginButton)
  }

  private func configureConstraints() {
    welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
    emailLabel.translatesAutoresizingMaskIntoConstraints = false
    emailTextField.translatesAutoresizingMaskIntoConstraints = false
    passwordLabel.translatesAutoresizingMaskIntoConstraints = false
    passwordTextField.translatesAutoresizingMaskIntoConstraints = false
    forgetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
    signupButton.translatesAutoresizingMaskIntoConstraints = false
    loginButton.translatesAutoresizingMaskIntoConstraints = false

    let safeAreaLayoutGuide = view.safeAreaLayoutGuide
    let marginsGuide = view.layoutMarginsGuide
    let constraints = [
      welcomeLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      welcomeLabel.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor),
      welcomeLabel.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor),

      emailLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: VerticalPadding.standard.rawValue * 2),
      emailLabel.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
      emailLabel.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor),

      emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: VerticalPadding.small.rawValue),
      emailTextField.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
      emailTextField.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor),
      emailTextField.heightAnchor.constraint(equalToConstant: TextFieldHeight),

      passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: VerticalPadding.standard.rawValue),
      passwordLabel.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
      passwordLabel.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor),

      passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: VerticalPadding.small.rawValue),
      passwordTextField.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
      passwordTextField.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor),
      passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),

      forgetPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: VerticalPadding.medium.rawValue),
      forgetPasswordButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),

      signupButton.topAnchor.constraint(equalTo: forgetPasswordButton.topAnchor),
      signupButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),

      loginButton.topAnchor.constraint(equalTo: forgetPasswordButton.bottomAnchor, constant: VerticalPadding.standard.rawValue),
      loginButton.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
      loginButton.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor),
      loginButton.heightAnchor.constraint(equalToConstant: LoginButtonHeight)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - Actions

  @objc private func didTapLogin(_ button: UIButton) {
    guard let identification = emailTextField.text, !identification.isEmpty else {
      emailTextField.shake {
        self.emailTextField.becomeFirstResponder()
      }
      return
    }
    guard let password = passwordTextField.text, !password.isEmpty else {
      passwordTextField.shake {
        self.passwordTextField.becomeFirstResponder()
      }
      return
    }
    view.endEditing(true)
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    CrowsServices.shared.login(identification: identification, password: password) { success, error in
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
      self.delegate?.signInViewController(self, didLogin: true, nil)
      guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
      UIView.transition(with: keyWindow, duration: 1, options: .transitionCurlUp, animations: {
        UIView.setAnimationsEnabled(false)
        keyWindow.rootViewController = RootTabBarViewController()
        UIView.setAnimationsEnabled(true)
      }, completion: nil)
    }
  }

  @objc private func didTapForgetPassword(_ button: UIButton) {
    let forgetPasswordViewController = ForgetPasswordViewController()
    navigationController?.pushViewController(forgetPasswordViewController, animated: true)
  }

  @objc private func didTapSignup(_ button: UIButton) {
    let signupViewController = SignupViewController()
    navigationController?.pushViewController(signupViewController, animated: true)
  }

}
