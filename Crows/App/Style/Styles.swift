//
//  Styles.swift
//  Crows
//
//  Created by Yingwei Fan on 4/30/21.
//

import UIKit

enum HorizontalPadding: CGFloat {
  case small = 4.0
  case medium = 8.0
  case standard = 16.0
}

enum VerticalPadding: CGFloat {
  case small = 4.0
  case medium = 8.0
  case standard = 20.0
}

enum CornerRadius: CGFloat {
  case small = 5.0
  case medium = 10.0
  case large = 20.0
}

extension UIView {
  // TODO: Not finished.
  func roundCorners(corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }

  func addBorder(edges: UIRectEdge, width: CGFloat, color: CGColor = CrowsColor.grey300.cgColor) {
    layer.masksToBounds = true
    if edges == .all {
      let border = CALayer()
      border.borderColor = color
      border.borderWidth = width
      return
    }
    if edges.contains(.top) {

    }
    if edges.contains(.left) {

    }
    if edges.contains(.right) {

    }
    if edges.contains(.bottom) {
      let border = CALayer()
      border.borderColor = color
      border.frame = CGRect(origin: CGPoint(x: 0, y :frame.size.height - width),
                            size: CGSize(width: frame.size.width, height: frame.size.height))
      border.borderWidth = width
      layer.addSublayer(border)
    }
  }

  func addBottomSeparator(width: CGFloat, color: UIColor = CrowsColor.grey300) {
    let separator = UIView()
    separator.backgroundColor = color
    addSubview(separator)
    separator.translatesAutoresizingMaskIntoConstraints = false
    let constraints = [
      separator.leadingAnchor.constraint(equalTo: leadingAnchor),
      separator.trailingAnchor.constraint(equalTo: trailingAnchor),
      separator.bottomAnchor.constraint(equalTo: bottomAnchor),
      separator.heightAnchor.constraint(equalToConstant: width)
    ]
    NSLayoutConstraint.activate(constraints)
  }
}
