//
//  HomeViewController.swift
//  Crows
//
//  Created by Yingwei Fan on 3/29/21.
//

import UIKit

class HomeViewController: UIViewController {

  private let contentFeedViewController = ContentFeedViewController()

  private let circlesListViewController = CirclesListViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let homeTitle = NSLocalizedString("Home", comment: "")
//    let circlesTitle = NSLocalizedString("Circles", comment: "")
    let titles = [homeTitle]
    let segmentedControl = UISegmentedControl(items: titles)
    segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: CrowsColor.grey800], for: .normal)
    segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: CrowsColor.grey900], for: .selected)
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.addTarget(self, action: #selector(didTapSegmentedControl(_:)), for: .valueChanged)
    navigationItem.titleView = segmentedControl

    addChild(contentFeedViewController)
//    addChild(circlesListViewController)
    view.addSubview(contentFeedViewController.view)
//    view.addSubview(circlesListViewController.view)

    contentFeedViewController.didMove(toParent: self)
//    circlesListViewController.didMove(toParent: self)

//    contentFeedViewController.view.frame = view.bounds
//    circlesListViewController.view.frame = view.bounds
//    circlesListViewController.view.isHidden = true
  }
  
  // MARK: - Actions

  @objc private func didTapSegmentedControl(_ segmentedControl: UISegmentedControl) {
    contentFeedViewController.view.isHidden = true
    circlesListViewController.view.isHidden = true
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      contentFeedViewController.view.isHidden = false
    case 1:
      circlesListViewController.view.isHidden = false
    default:
      break;
    }
  }
  
}
