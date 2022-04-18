//
//  AddYouTubeLinkViewController.swift
//  Crows
//
//  Created by Yingwei Fan on 4/21/21.
//

import UIKit
import YouTubePlayer

protocol AddYouTubeLinkViewControllerDelegate: NSObjectProtocol {
  func addYouTubeLinkViewController(_ viewController: AddYouTubeLinkViewController, didAdd youtubeVideoLink: String)
}

class AddYouTubeLinkViewController: UIViewController, UITextFieldDelegate {

  private let titleLabel = UILabel()

  private let descriptionLabel = UILabel()

  private let textField = RoundTextField()

  private let addLinkButton = UIButton()

  private let closeButton = UIButton()

  weak var delegate: AddYouTubeLinkViewControllerDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = CrowsColor.white
    configureSubviews()
    configureConstraints()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    textField.becomeFirstResponder()
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
      addLinkButton.layer.borderColor = CrowsColor.grey800.cgColor
    }
  }

  // MARK: - Private

  private func configureSubviews() {
    titleLabel.font = CrowsFont.contentTitle
    titleLabel.textColor = CrowsColor.grey900
    titleLabel.numberOfLines = 1
    titleLabel.text = NSLocalizedString("CreateContent.AddYouTubeLinkTitle", comment: "")
    view.addSubview(titleLabel)

    descriptionLabel.font = CrowsFont.text
    descriptionLabel.textColor = CrowsColor.grey900
    descriptionLabel.numberOfLines = 0
    descriptionLabel.text = NSLocalizedString("CreateContent.AddYouTubeLinkDescription", comment: "")
    view.addSubview(descriptionLabel)

    textField.keyboardType = .URL
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .none
    textField.delegate = self
    view.addSubview(textField)

    addLinkButton.setTitle(NSLocalizedString("Add", comment: ""), for: .normal)
    addLinkButton.setTitleColor(CrowsColor.grey900, for: .normal)
    addLinkButton.titleLabel?.font = CrowsFont.buttonBig
    addLinkButton.layer.cornerRadius = CornerRadius.small.rawValue
    addLinkButton.layer.masksToBounds = true
    addLinkButton.layer.borderWidth = 2.0
    addLinkButton.layer.borderColor = CrowsColor.grey800.cgColor
    addLinkButton.addTarget(self, action: #selector(didTapAddLink(_:)), for: .touchUpInside)
    view.addSubview(addLinkButton)

    closeButton.tintColor = CrowsColor.grey900
    closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
    closeButton.addTarget(self, action: #selector(didTapClose(_:)), for: .touchUpInside)
    view.addSubview(closeButton)
  }

  private func configureConstraints() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    textField.translatesAutoresizingMaskIntoConstraints = false
    addLinkButton.translatesAutoresizingMaskIntoConstraints = false
    closeButton.translatesAutoresizingMaskIntoConstraints = false

    let marginsGuide = view.layoutMarginsGuide
    let constraints = [
      titleLabel.topAnchor.constraint(equalTo: marginsGuide.topAnchor, constant: VerticalPadding.standard.rawValue * 3),
      titleLabel.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor),

      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: VerticalPadding.medium.rawValue),
      descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

      textField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: VerticalPadding.medium.rawValue * 2),
      textField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      textField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      textField.heightAnchor.constraint(equalToConstant: 40.0),

      addLinkButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: VerticalPadding.standard.rawValue * 2),
      addLinkButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      addLinkButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      addLinkButton.heightAnchor.constraint(equalToConstant: 40.0),

      closeButton.topAnchor.constraint(equalTo: marginsGuide.topAnchor, constant: VerticalPadding.standard.rawValue),
      closeButton.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor),
      closeButton.widthAnchor.constraint(equalToConstant: 30.0),
      closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - Actions

  @objc private func didTapAddLink(_ button: UIButton) {
    guard let youtubeLink = textField.text else {
      // TODO: Display alert that the link is invalid.
      debugPrint("Link is invalid")
      return
    }

    delegate?.addYouTubeLinkViewController(self, didAdd: youtubeLink)
    dismiss(animated: true, completion: nil)
  }

  @objc private func didTapClose(_ button: UIButton) {
    dismiss(animated: true, completion: nil)
  }

}
