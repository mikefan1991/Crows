//
//  AnimationUtils.swift
//  Crows
//
//  Created by Yingwei Fan on 5/21/21.
//

import UIKit

extension UIView {

  func shake(completion: (() -> Void)? = nil) {
    self.transform = CGAffineTransform(translationX: 8, y: 0)
    UIView.animate(withDuration: 0.3,
                   delay: 0,
                   usingSpringWithDamping: 0.1,
                   initialSpringVelocity: 0.3,
                   options: .curveEaseInOut) {
      self.transform = CGAffineTransform.identity
    } completion: {_ in
      if let completion = completion {
        completion()
      }
    }
  }

}
