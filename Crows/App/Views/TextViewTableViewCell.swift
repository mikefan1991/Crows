//
//  TextViewTableViewCell.swift
//  Crows
//
//  Created by Yingwei Fan on 4/9/21.
//

import UIKit

private let TextViewInitialHeight: CGFloat = 100.0

protocol TextViewTableViewCellDelegate: NSObjectProtocol {
  func textViewTableViewCell(_ cell: TextViewTableViewCell, didBeginEditing textView: UITextView)
  func textViewTableViewCell(_ cell: TextViewTableViewCell, didChange textView: UITextView)
}

class TextViewTableViewCell: UITableViewCell, UITextViewDelegate {

  let textView = UITextView()

  weak var delegate: TextViewTableViewCellDelegate?

  var placeholder: String? {
    didSet {
      if !textView.hasText, !textView.isFocused {
        textView.text = placeholder
      }
    }
  }

  var placeholderTextColor = UIColor.systemGray.withAlphaComponent(0.6)

  private(set) var isShowingPlaceholder = true

  var cursorRect: CGRect {
    guard let endPosition = textView.selectedTextRange?.end else { return .zero }
    return textView.caretRect(for: endPosition)
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    backgroundColor = .clear

    textView.backgroundColor = .clear
    textView.tintColor = CrowsColor.grey900
    textView.textColor = placeholderTextColor
    textView.font = CrowsFont.text
    textView.layer.cornerRadius = CornerRadius.small.rawValue
    textView.layer.masksToBounds = true
    textView.layer.borderWidth = 1.0
    textView.layer.borderColor = CrowsColor.grey650.cgColor
    textView.isScrollEnabled = false
    textView.textContainerInset = UIEdgeInsets(top: 5.0, left: 2.5, bottom: 5.0, right: 2.5)
    textView.delegate = self
    contentView.addSubview(textView)

    let marginsGuide = contentView.layoutMarginsGuide
    textView.translatesAutoresizingMaskIntoConstraints = false
    let constraints = [
      textView.topAnchor.constraint(equalTo: marginsGuide.topAnchor),
      textView.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor),
      textView.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor),
      textView.bottomAnchor.constraint(equalTo: marginsGuide.bottomAnchor),
      textView.heightAnchor.constraint(greaterThanOrEqualToConstant: TextViewInitialHeight)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
      textView.layer.borderColor = CrowsColor.grey650.cgColor
    }
  }

  // MARK: - UITextViewDelegate

  func textViewDidBeginEditing(_ textView: UITextView) {
    if isShowingPlaceholder {
      textView.text = nil
      textView.textColor = CrowsColor.grey800
      isShowingPlaceholder = false
    }
    delegate?.textViewTableViewCell(self, didBeginEditing: textView)
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if !textView.hasText {
      textView.text = placeholder
      textView.textColor = placeholderTextColor
      isShowingPlaceholder = true
    }
  }

  func textViewDidChange(_ textView: UITextView) {
    delegate?.textViewTableViewCell(self, didChange: textView)
  }

}
