//
//  RootViewController.swift
//  Crows
//
//  Created by Yingwei Fan on 3/29/21.
//

import UIKit

class RootTabBarViewController: UITabBarController, UITabBarControllerDelegate, RootTabBarDelegate {

  private var tabBarLastSelectedIndex = 0

  let customTabBar = RootTabBar()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    customTabBar.buttonDelegate = self
    setValue(customTabBar, forKey: "tabBar")
    configureTabs()

    delegate = self
  }

  // MARK: - Private

  private func configureTabs() {
    let homeViewController = HomeViewController()
    homeViewController.tabBarItem = UITabBarItem(title: nil, image: Tab.home.icon(), tag: Tab.home.rawValue)
    let homeNavController = BaseNavigationController(rootViewController: homeViewController)

    let profileViewController = ProfileViewController()
    profileViewController.tabBarItem = UITabBarItem(title: nil, image: Tab.profile.icon(), tag: Tab.profile.rawValue)
    let profileNavController = BaseNavigationController(rootViewController: profileViewController)

    viewControllers = [homeNavController, profileNavController]

    tabBar.tintColor = CrowsColor.grey900
  }

  // MARK: - RootTabBarDelegate

  func rootTabBar(_ tabBar: RootTabBar, didTapCreate button: UIButton) {
    let createContentViewController = CreateContentViewController()
    let navigationController = BaseNavigationController(rootViewController: createContentViewController)
    navigationController.modalPresentationStyle = .fullScreen
    present(navigationController, animated: true, completion: nil)
  }
}
