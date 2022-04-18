//
//  CirclePageContentView.swift
//  Crows
//
//  Created by Yingwei Fan on 4/14/21.
//

import UIKit

private let PageCellReuseIdentifier = "CirclePageCell"

protocol CirclePageContentViewDelegate: NSObjectProtocol {
  func circlePageContentView(_ contentView: CirclePageContentView, didScroll progress: CGFloat, to index: Int)
}

class CirclePageContentView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

  private let childViewControllers: [UIViewController & CirclePageContentScrollable]

  private let parentViewController: CircleDetailsBaseViewController

  weak var delegate: CirclePageContentViewDelegate?

  lazy private var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumLineSpacing = 0
    flowLayout.minimumInteritemSpacing = 0
    flowLayout.scrollDirection = .horizontal

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.isPagingEnabled = true
    collectionView.bounces = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: PageCellReuseIdentifier)
    return collectionView
  }()

  var baseScrollableCallback: ((Bool) -> Void)?

  // Whether the scrolling of the collevtion view is forced by tapping the page selection view.
  private var forceScroll = false

  required init(frame: CGRect,
                childViewControllers: [UIViewController & CirclePageContentScrollable],
                parentViewController: CircleDetailsBaseViewController) {
    self.childViewControllers = childViewControllers
    self.parentViewController = parentViewController
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

  // MARK: - Public

  func scrollToPage(_ index: Int, animated: Bool) {
    forceScroll = true
    collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animated)
  }

  // MARK: - Private

  private func configureSubviews() {
    for child in childViewControllers {
      parentViewController.addChild(child)
    }

    addSubview(collectionView)
  }

  private func configureConstraints() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false

    let constraints = [
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - UICollectionViewDataSource

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return childViewControllers.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCellReuseIdentifier, for: indexPath)

    for subview in cell.contentView.subviews {
      subview.removeFromSuperview()
    }
    let childViewController = childViewControllers[indexPath.item]
    childViewController.view.frame = cell.contentView.bounds
    cell.contentView.addSubview(childViewController.view)

    return cell
  }

  // MARK: - UICollectionViewDelegateFlowLayout

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return bounds.size
  }

  // MARK: - UIScrollViewDelegate

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    // When the collection view is scrolling, the vertical scrolling of the base view controller should be disabled.
    parentViewController.isScrollEnabled = false
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    parentViewController.isScrollEnabled = true
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard !forceScroll else { return }
    let progress = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.bounds.width)
    let index = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
    delegate?.circlePageContentView(self, didScroll: progress, to: index)
  }

  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    forceScroll = false
  }

}
