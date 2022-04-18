//
//  RootTabBar.swift
//  Crows
//
//  Created by Yingwei Fan on 3/30/21.
//

import UIKit

enum Tab: Int, CaseIterable {
  case home
  case profile

  func icon() -> UIImage {
    let iconConfiguration = UIImage.SymbolConfiguration(weight: .bold)
    var iconSystemName = ""
    switch self {
    case .home:
      iconSystemName = "house.fill"
    case .profile:
      iconSystemName = "person.fill"
    }
    guard let icon = UIImage(systemName: iconSystemName, withConfiguration: iconConfiguration) else {
      return UIImage()
    }
    return icon
  }
}

private let createButtonIconSize: CGFloat = 40.0

protocol RootTabBarDelegate: NSObjectProtocol {
  func rootTabBar(_ tabBar:RootTabBar, didTapCreate button: UIButton)
}

class RootTabBar: UITabBar {

  weak var buttonDelegate: RootTabBarDelegate?

  private lazy var createButton: UIButton = {
    let button = UIButton()
    let config = UIImage.SymbolConfiguration(pointSize: createButtonIconSize)
    let buttonImage = UIImage(systemName: "plus.rectangle.fill", withConfiguration: config)
    button.setImage(buttonImage, for: .normal)
    button.tintColor = .orange
    button.addTarget(self, action: #selector(didTapCreateButton(_:)), for: .touchUpInside)
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    barTintColor = CrowsColor.white
    isTranslucent = false
    addSubview(createButton)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    let numberOfTabs = Tab.allCases.count + 1
    let middleIndex = numberOfTabs / 2
    let tabWidth = frame.width / CGFloat(numberOfTabs)
    var tabIndex = 0
    for subview in subviews {
      if subview.isKind(of: NSClassFromString("UITabBarButton")!) {
        if tabIndex == middleIndex {
          createButton.frame = CGRect(x: CGFloat(tabIndex) * tabWidth, y: 0, width: tabWidth, height: subview.frame.height)
          tabIndex += 1
        }
        subview.frame = CGRect(x: CGFloat(tabIndex) * tabWidth, y: 0, width: tabWidth, height: subview.frame.height)
        tabIndex += 1
      }
    }
  }

  // MARK: - Actions

  @objc private func didTapCreateButton(_ button: UIButton) {
    buttonDelegate?.rootTabBar(self, didTapCreate: button)
  }

}
