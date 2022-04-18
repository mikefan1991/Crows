//
//  SignInNavigationController.swift
//  Crows
//
//  Created by Yingwei Fan on 4/24/21.
//

import UIKit

class SignInNavigationController: BaseNavigationController {

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.isTranslucent = true
    navigationBar.shadowImage = UIImage()
  }

}
