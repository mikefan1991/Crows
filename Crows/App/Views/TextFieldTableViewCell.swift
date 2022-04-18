//
//  TextFieldTableViewCell.swift
//  Crows
//
//  Created by Yingwei Fan on 4/9/21.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

  let textField = UITextField()

  var placeholder: String? {
    didSet {
      textField.placeholder = placeholder
    }
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    backgroundColor = .clear

    textField.textColor = CrowsColor.grey900
    textField.tintColor = CrowsColor.grey900
    textField.addBottomSeparator(width: 1.0, color: CrowsColor.grey300)
    contentView.addSubview(textField)
    let marginsGuide = contentView.layoutMarginsGuide
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.topAnchor.constraint(equalTo: marginsGuide.topAnchor).isActive = true
    textField.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor).isActive = true
    textField.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor).isActive = true
    textField.bottomAnchor.constraint(equalTo: marginsGuide.bottomAnchor).isActive = true
    textField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
