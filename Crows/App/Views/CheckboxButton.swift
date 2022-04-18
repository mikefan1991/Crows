//
//  CheckboxButton.swift
//  Crows
//
//  Created by Yingwei Fan on 4/24/21.
//

import UIKit

class CheckboxButton: UIView {

  let checkmarkImage = UIImage(systemName: "checkmark")

  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .clear
    return imageView
  }()

  var isChecked = false {
    didSet {
      if isChecked {
        imageView.image = checkmarkImage
      } else {
        imageView.image = nil
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    setContentHuggingPriority(.required, for: .horizontal)
    setContentHuggingPriority(.required, for: .vertical)
    setContentCompressionResistancePriority(.required, for: .horizontal)
    setContentHuggingPriority(.required, for: .vertical)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.tintColor = CrowsColor.blue
    addSubview(imageView)
    layer.cornerRadius = 2.0
    layer.masksToBounds = true
    layer.borderWidth = 1.0
    layer.borderColor = CrowsColor.grey800.cgColor

    let constraints = [
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override var intrinsicContentSize: CGSize {
    return CGSize(width: 16.0, height: 16.0)
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
      layer.borderColor = CrowsColor.grey800.cgColor
    }
  }

  func toggle() {
    isChecked = !isChecked
  }

}
