//
//  CodeConfirmationViewController.swift
//  Crows
//
//  Created by Yingwei Fan on 4/24/21.
//

import UIKit

private let NumberOfCodeDigits = 6
private let CodeInputViewHeight: CGFloat = 60.0
private let ResendCoolDownTime = 60

class CodeConfirmationViewController: UIViewController, CodeTextFieldDelegate {

  private let confirmationLabel = UILabel()

  private let descriptionLabel = UILabel()

  private let codeTextField = CodeTextField(numberOfDigits: NumberOfCodeDigits)

  private let resendButton = UIButton()

  private var timer: Timer?

  private var totalCoolDownTime = ResendCoolDownTime

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = CrowsColor.white
    configureSubviews()
    configureConstraints()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    codeTextField.becomeFirstResponder()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    timer?.invalidate()
    timer = nil
  }

  // MARK: - Private

  private func configureSubviews() {
    confirmationLabel.font = CrowsFont.pageTitle
    confirmationLabel.textColor = CrowsColor.grey900
    confirmationLabel.textAlignment = .center
    confirmationLabel.numberOfLines = 1
    confirmationLabel.text = NSLocalizedString("SignIn.ConfirmationTitle", comment: "")
    view.addSubview(confirmationLabel)

    descriptionLabel.font = CrowsFont.text
    descriptionLabel.textColor = CrowsColor.grey900
    descriptionLabel.textAlignment = .center
    descriptionLabel.numberOfLines = 0
    descriptionLabel.text = NSLocalizedString("SignIn.ConfirmationDescription", comment: "")
    view.addSubview(descriptionLabel)

    codeTextField.codeDelegate = self
    view.addSubview(codeTextField)

    resendButton.setTitle(NSLocalizedString("SignIn.ResendCode", comment: ""), for: .normal)
    resendButton.setTitleColor(CrowsColor.grey900, for: .normal)
    resendButton.setTitleColor(CrowsColor.grey650, for: .highlighted)
    resendButton.setTitleColor(CrowsColor.grey300, for: .disabled)
    resendButton.titleLabel?.font = CrowsFont.text
    resendButton.addTarget(self, action: #selector(didTapResend(_:)), for: .touchUpInside)
    view.addSubview(resendButton)
  }

  private func configureConstraints() {
    confirmationLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    codeTextField.translatesAutoresizingMaskIntoConstraints = false
    resendButton.translatesAutoresizingMaskIntoConstraints = false

    let safeAreaLayoutGuide = view.safeAreaLayoutGuide
    let marginsGuide = view.layoutMarginsGuide
    let constraints = [
      confirmationLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      confirmationLabel.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor),
      confirmationLabel.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor),

      descriptionLabel.topAnchor.constraint(equalTo: confirmationLabel.bottomAnchor, constant: VerticalPadding.standard.rawValue),
      descriptionLabel.leadingAnchor.constraint(equalTo: confirmationLabel.leadingAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: confirmationLabel.trailingAnchor),

      codeTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: VerticalPadding.standard.rawValue * 2),
      codeTextField.leadingAnchor.constraint(equalTo: confirmationLabel.leadingAnchor),
      codeTextField.trailingAnchor.constraint(equalTo: confirmationLabel.trailingAnchor),
      codeTextField.heightAnchor.constraint(equalToConstant: CodeInputViewHeight),

      resendButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: VerticalPadding.standard.rawValue),
      resendButton.centerXAnchor.constraint(equalTo: confirmationLabel.centerXAnchor),
      resendButton.widthAnchor.constraint(equalTo: confirmationLabel.widthAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - Actions

  @objc private func didTapResend(_ button: UIButton) {
    button.isEnabled = false
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    timer?.fire()
  }

  @objc private func timerAction() {
    if totalCoolDownTime > 0 {
      totalCoolDownTime -= 1
      let buttonTitle = NSLocalizedString("SignIn.ResendCode", comment: "") + " (\(totalCoolDownTime))"
      resendButton.setTitle(buttonTitle, for: .disabled)
    } else {
      resendButton.isEnabled = true
      timer?.invalidate()
      timer = nil
      totalCoolDownTime = ResendCoolDownTime
    }
  }

  // MARK: - CodeTextFieldDelegate

  fileprivate func codeTextField(_ textField: CodeTextField, didFinishInput code: String) {
//    let setPasswordViewController = SetPasswordViewController()
//    navigationController?.pushViewController(setPasswordViewController, animated: true)
  }

}

// MARK: - ContentInputView -

private protocol CodeTextFieldDelegate: UITextFieldDelegate {
  func codeTextField(_ textField: CodeTextField, didFinishInput code: String)
}

private class CodeTextField: UITextField {

  private var digitCount = 0

  private let stackView = UIStackView()

  private var digitLabels: [UILabel]

  weak var codeDelegate: CodeTextFieldDelegate?

  init(numberOfDigits: Int, frame: CGRect = .zero) {
    digitLabels = [UILabel]()
    super.init(frame: frame)

    digitCount = numberOfDigits
    tintColor = CrowsColor.grey900
    textColor = CrowsColor.grey900
    font = CrowsFont.buttonBig
    configureSubviews()
    configureConstraints()
  }

  @available(*, unavailable)
  override init(frame: CGRect) {
    fatalError("init(frame:) cannot be used")
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func caretRect(for position: UITextPosition) -> CGRect {
    let currentIndex = text?.count ?? 0
    guard currentIndex < digitCount else {
      return .zero
    }
    let superRect = super.caretRect(for: position)
    let x = digitLabels[currentIndex].center.x
    return CGRect(x: x, y: superRect.minY, width: superRect.width, height: superRect.height)
  }

  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    return false
  }

  // MARK: - Private

  private func configureSubviews() {
    textColor = .clear

    keyboardType = .numberPad
    addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    addTarget(self, action: #selector(textFieldEditingDidBegin), for: .editingDidBegin)

    stackView.distribution = .fillEqually
    stackView.axis = .horizontal
    stackView.spacing = HorizontalPadding.medium.rawValue
    stackView.isUserInteractionEnabled = false
    addSubview(stackView)

    for i in 0..<digitCount {
      let label = UILabel()
      label.backgroundColor = CrowsColor.grey300
      label.font = CrowsFont.contentTitle
      label.textAlignment = .center
      label.tag = i
      label.layer.cornerRadius = CornerRadius.small.rawValue
      label.layer.masksToBounds = true
      digitLabels.append(label)
      stackView.addArrangedSubview(label)
    }
  }

  private func configureConstraints() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    let constraints = [
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  private func updateLabels() {
    let text = self.text ?? ""
    digitLabels.forEach { (label) in
      if label.tag >= text.count {
        label.text = nil
      } else {
        let index = text.index(text.startIndex, offsetBy: label.tag)
        label.text = String(text[index])
      }
    }
  }

  private func clearCode() {
    text = nil
  }

  // MARK: - Actions

  @objc private func textFieldEditingDidBegin() {
    text = nil
    updateLabels()
  }

  @objc private func textFieldEditingChanged() {
    updateLabels()
    if let text = self.text, text.count == digitCount {
      resignFirstResponder()
      codeDelegate?.codeTextField(self, didFinishInput: text)
    }
  }

}
