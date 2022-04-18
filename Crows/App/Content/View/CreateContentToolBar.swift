//
//  CreateContentToolBar.swift
//  Crows
//
//  Created by Yingwei Fan on 4/10/21.
//

import UIKit

private let StackHeight: CGFloat = 30.0

enum ToolBarContentType {
  case image
  case externalVideo
  case forwardContent
  case none
}

protocol CreateContentToolBarDelegate: NSObjectProtocol {
  func createContentToolBar(_ toolBar: CreateContentToolBar, didTapAddImage button: UIButton)
  func createContentToolBar(_ toolBar: CreateContentToolBar, didTapAddExternalVideo button: UIButton)
}

class CreateContentToolBar: UIView {

  private let stackView = UIStackView()

  private let addImageButton = UIButton()

  private let addExternalVideoButton = UIButton()

  var contentType = ToolBarContentType.none {
    didSet {
      switch contentType {
      case .image:
        addExternalVideoButton.isEnabled = false
      case .externalVideo:
        addImageButton.isEnabled = false
      case .forwardContent:
        addImageButton.isEnabled = false
        addExternalVideoButton.isEnabled = false
      case .none:
        addImageButton.isEnabled = true
        addExternalVideoButton.isEnabled = true
      }
    }
  }

  weak var delegate: CreateContentToolBarDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = CrowsColor.background1
    layer.shadowColor = CrowsColor.shadow.cgColor
    layer.shadowOpacity = 0.7
    layer.shadowOffset = CGSize(width: 0, height: 1)
    layer.shadowRadius = 3.0
    configureSubviews()
    configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
      layer.shadowColor = CrowsColor.shadow.cgColor
    }
  }

  // MARK: - Private

  private func configureSubviews() {
    addImageButton.tintColor = CrowsColor.grey900
    addImageButton.setImage(UIImage(systemName: "photo.fill.on.rectangle.fill"), for: .normal)
    addImageButton.setTitle(NSLocalizedString("CreateContent.InsertPhotos", comment: ""), for: .normal)
    addImageButton.setTitleColor(CrowsColor.grey900, for: .normal)
    addImageButton.setTitleColor(CrowsColor.grey650, for: .highlighted)
    addImageButton.titleLabel?.font = CrowsFont.buttonSmall
    addImageButton.addTarget(self, action: #selector(didTapAddImageButton(_:)), for: .touchUpInside)
    stackView.addArrangedSubview(addImageButton)

    addExternalVideoButton.tintColor = CrowsColor.grey900
    addExternalVideoButton.setImage(UIImage(systemName: "link.circle.fill"), for: .normal)
    addExternalVideoButton.setTitle(NSLocalizedString("CreateContent.InsertExternalVideo", comment: ""), for: .normal)
    addExternalVideoButton.setTitleColor(CrowsColor.grey900, for: .normal)
    addExternalVideoButton.setTitleColor(CrowsColor.grey650, for: .highlighted)
    addExternalVideoButton.titleLabel?.font = CrowsFont.buttonSmall
    addExternalVideoButton.addTarget(self, action: #selector(didTapAddExternalVideoButton(_:)), for: .touchUpInside)
    stackView.addArrangedSubview(addExternalVideoButton)

    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    addSubview(stackView)
  }

  private func configureConstraints() {
    stackView.translatesAutoresizingMaskIntoConstraints = false

    let constraints = [
      stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
      stackView.heightAnchor.constraint(equalToConstant: StackHeight)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - Actions

  @objc private func didTapAddImageButton(_ button: UIButton) {
    delegate?.createContentToolBar(self, didTapAddImage: button)
  }

  @objc private func didTapAddExternalVideoButton(_ button: UIButton) {
    delegate?.createContentToolBar(self, didTapAddExternalVideo: button)
  }

}
