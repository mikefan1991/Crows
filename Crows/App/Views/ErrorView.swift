//
//  ErrorView.swift
//  Crows
//
//  Created by Yingwei Fan on 5/5/21.
//

import UIKit

protocol ErrorViewDelegate: NSObjectProtocol {
  func errorView(_ errorView: ErrorView, didTapRetry button: UIButton)
}

class ErrorView: UIView {

  private let titleLabel = UILabel()

  private let messageLabel = UILabel()

  private let retryButton = UIButton()

  weak var delegate: ErrorViewDelegate?

  var error: NSError? {
    didSet {
      guard let error = error else { return }
      titleLabel.text = error.localizedDescription
      messageLabel.text = "Please retry in a moment"
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    configureSubviews()
    configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private

  private func configureSubviews() {
    titleLabel.font = CrowsFont.contentTitle
    titleLabel.textColor = CrowsColor.grey900
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 0
    addSubview(titleLabel)

    messageLabel.font = CrowsFont.text
    messageLabel.textColor = CrowsColor.grey650
    messageLabel.textAlignment = .center
    messageLabel.numberOfLines = 0
    addSubview(messageLabel)

    retryButton.setTitle(NSLocalizedString("Retry", comment: ""), for: .normal)
    retryButton.setTitleColor(CrowsColor.grey900, for: .normal)
    retryButton.titleLabel?.font = CrowsFont.buttonSmall
    retryButton.addTarget(self, action: #selector(didTapRetry(_:)), for: .touchUpInside)
    addSubview(retryButton)
  }

  private func configureConstraints() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    retryButton.translatesAutoresizingMaskIntoConstraints = false

    let constraints = [
      messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      messageLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),

      titleLabel.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -VerticalPadding.medium.rawValue),

      retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: VerticalPadding.medium.rawValue),
      retryButton.centerXAnchor.constraint(equalTo: messageLabel.centerXAnchor),
      retryButton.widthAnchor.constraint(equalToConstant: 60.0)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - Actions

  @objc private func didTapRetry(_ button: UIButton) {
    delegate?.errorView(self, didTapRetry: button)
  }

}
