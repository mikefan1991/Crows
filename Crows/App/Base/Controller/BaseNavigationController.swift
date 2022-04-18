//
//  BaseNavigationController.swift
//  Crows
//
//  Created by Yingwei Fan on 3/30/21.
//

import UIKit

class BaseNavigationController: UINavigationController {

  lazy private var backButtonItem: UIBarButtonItem = {
    let backButton = UIButton()
    backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
    return UIBarButtonItem(customView: backButton)
  }()

  override func viewDidLoad() {
    // Change navigation bar's background color.
    navigationBar.isTranslucent = false
    navigationBar.barTintColor = CrowsColor.background
    // Change navigation bar's item color.
    navigationBar.tintColor = CrowsColor.grey900
    // Change navigation bar's title color.
    navigationBar.titleTextAttributes = [.foregroundColor: CrowsColor.grey900]
  }

  override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    topViewController?.navigationItem.backBarButtonItem = backButtonItem
    if viewControllers.count >= 1 {
      viewController.hidesBottomBarWhenPushed = true
    }
    super.pushViewController(viewController, animated: animated)
  }

  override var childForStatusBarStyle: UIViewController? {
    return topViewController
  }

}
