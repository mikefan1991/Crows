//
//  CirclePageView.swift
//  CirclePageDemo
//
//  Created by Yingwei Fan on 4/14/21.
//

import UIKit

private let PageSelectionViewHeight: CGFloat = 40.0

class CirclePageView: UIView, CirclePageSelectionViewDelegate, CirclePageContentViewDelegate {

  private let pageTitles: [String]

  private let childViewControllers: [UIViewController & CirclePageContentScrollable]

  private let parentViewController: CircleDetailsBaseViewController

  lazy private var pageSelectionView: CirclePageSelectionView = {
    return CirclePageSelectionView(frame: .zero, pageTitles: pageTitles)
  }()

  lazy private var contentView: CirclePageContentView = {
    return CirclePageContentView(frame: .zero, childViewControllers: childViewControllers, parentViewController: parentViewController)
  }()

  var currentChildViewController: CirclePageContentScrollable?

  var childViewControllerCanScroll = false

  required init(frame: CGRect,
                pageTitles: [String],
                childViewControllers: [UIViewController & CirclePageContentScrollable],
                parentViewController: CircleDetailsBaseViewController) {
    self.pageTitles = pageTitles
    self.childViewControllers = childViewControllers
    self.parentViewController = parentViewController
    currentChildViewController = childViewControllers.first
    super.init(frame: frame)

    configureSubviews()
    configureConstraints()
  }

  @available(*, unavailable)
  init() {
    fatalError("init() cannot be used")
  }

  @available(*, unavailable)
  override init(frame: CGRect) {
    fatalError("init(frame:) cannot be used")
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private

  private func configureSubviews() {
    pageSelectionView.addBottomSeparator(width: 1.0)
    pageSelectionView.delegate = self
    addSubview(pageSelectionView)

    contentView.delegate = self
    addSubview(contentView)
  }

  private func configureConstraints() {
    pageSelectionView.translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false

    let constraints = [
      pageSelectionView.topAnchor.constraint(equalTo: topAnchor),
      pageSelectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      pageSelectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      pageSelectionView.heightAnchor.constraint(equalToConstant: PageSelectionViewHeight),

      contentView.topAnchor.constraint(equalTo: pageSelectionView.bottomAnchor),
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - CirclePageSelectionViewDelegate

  func circlePageSelectionView(_ selectionView: CirclePageSelectionView, didSelect titleButton: UIButton) {
    let index = titleButton.tag
    contentView.scrollToPage(index, animated: true)
    currentChildViewController = childViewControllers[index]
    if parentViewController.baseScrollViewScrollable {
      currentChildViewController?.contentScrollable = false
    }
  }

  // MARK: - CirclePageContentViewDelegate

  func circlePageContentView(_ contentView: CirclePageContentView, didScroll progress: CGFloat, to index: Int) {
    pageSelectionView.bottomIndicatorProgress = progress

    guard index != pageSelectionView.selectedIndex else { return }
    pageSelectionView.selectedIndex = index
    currentChildViewController = childViewControllers[index]
    if parentViewController.baseScrollViewScrollable {
      currentChildViewController?.contentScrollable = false
    }
  }

}
