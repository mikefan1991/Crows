//
//  RoundTextField.swift
//  Crows
//
//  Created by Yingwei Fan on 4/30/21.
//

import UIKit

class RoundTextField: UITextField {

  var textInsets = UIEdgeInsets(top: 0, left: HorizontalPadding.medium.rawValue, bottom: 0, right: HorizontalPadding.medium.rawValue) {
    didSet {
      setNeedsDisplay()
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    layer.cornerRadius = CornerRadius.small.rawValue
    layer.masksToBounds = true
    layer.borderWidth = 1.0
    layer.borderColor = CrowsColor.grey800.cgColor
    tintColor = CrowsColor.grey900
    textColor = CrowsColor.grey900
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
      layer.borderColor = CrowsColor.grey800.cgColor
    }
  }

  override func textRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.textRect(forBounds: bounds)
    return rect.inset(by: textInsets)
  }

  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.editingRect(forBounds: bounds)
    return rect.inset(by: textInsets)
  }

}
