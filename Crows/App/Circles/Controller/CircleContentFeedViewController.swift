//
//  CircleContentFeedViewController.swift
//  Crows
//
//  Created by Yingwei Fan on 4/15/21.
//

import UIKit

class CircleContentFeedViewController: ContentFeedViewController, CirclePageContentScrollable {

  var contentScrollable = false

  var baseScrollableCallback: ((Bool) -> Void)?

  private var yOffsetBeforeDragging: CGFloat = 0

  override func viewDidLoad() {
    super.viewDidLoad()

    let bottomInset = navigationController?.view.safeAreaInsets.bottom ?? 0
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
    tableView.showsVerticalScrollIndicator = false
  }

  // MARK: - UIScrollViewDelegate

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    yOffsetBeforeDragging = scrollView.contentOffset.y
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if !contentScrollable {
      if scrollView.contentOffset.y <= 0 {
        scrollView.contentOffset.y = 0
      } else {
        scrollView.contentOffset.y = yOffsetBeforeDragging
      }
    } else {
      if scrollView.contentOffset.y <= 0 {
        contentScrollable = false
        baseScrollableCallback?(true)
      }
    }
  }

}
