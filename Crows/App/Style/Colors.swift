//
//  Colors.swift
//  Crows
//
//  Created by Yingwei Fan on 4/29/21.
//

import UIKit

class CrowsColor: NSObject {
  static let background = UIColor(named: "Background")!
  static let background1 = UIColor(named: "Background1")!
  static let background2 = UIColor(named: "Background2")!

  static let shadow = UIColor(named: "Shadow")!

  static let white = UIColor(named: "White")!
  static let grey900 = UIColor(named: "Grey900")!
  static let grey800 = UIColor(named: "Grey800")!
  static let grey650 = UIColor(named: "Grey650")!
  static let grey300 = UIColor(named: "Grey300")!

  static let blue = UIColor(named: "Blue")!
}

extension UIColor {
  var light: UIColor {
    return self.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
  }

  var dark: UIColor {
    return self.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
  }
}
