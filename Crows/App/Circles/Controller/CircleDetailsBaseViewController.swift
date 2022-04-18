//
//  CircleDetailsBaseViewController.swift
//  Crows
//
//  Created by Yingwei Fan on 4/14/21.
//

import UIKit

private let PageSelectionViewHeight: CGFloat = 40.0

class CircleDetailsBaseViewController: UIViewController, UIScrollViewDelegate {

  private let backgroundImageView = UIImageView()

  private let blurView: UIVisualEffectView = {
    let blurEffect = UIBlurEffect(style: .dark)
    return UIVisualEffectView(effect: blurEffect)
  }()

  private let baseScrollView = MultiResponseScrollView()

  private let headerView = CircleHeaderView()

  private var pageView: CirclePageView?

  var baseScrollViewScrollable = true

  var isScrollEnabled = true {
    didSet {
      baseScrollView.isScrollEnabled = isScrollEnabled
    }
  }

  lazy private var navigationTitleView: CircleNavigationTitleView = {
    let view = CircleNavigationTitleView()
    view.image = UIImage(named: "CircleTemplate")
    view.title = "Big circle"
    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = CrowsColor.background
    edgesForExtendedLayout = .top
    extendedLayoutIncludesOpaqueBars = true
    configureSubviews()
    configureConstraints()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.tintColor = CrowsColor.white.light
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    navigationController?.navigationBar.shadowImage = nil
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.tintColor = CrowsColor.grey900
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  // MARK: - Private

  private func configureSubviews() {
    backgroundImageView.image = UIImage(named: "CircleTemplate")
    backgroundImageView.contentMode = .scaleAspectFill
    backgroundImageView.addSubview(blurView)
    view.addSubview(backgroundImageView)

    let viewWidth = view.bounds.width
    let viewHeight = view.bounds.height

    let navigationBarHeight = navigationController?.navigationBar.frame.maxY ?? 0
    let headerHeight = headerView.sizeThatFits(view.bounds.size).height
    baseScrollView.contentSize = CGSize(width: viewWidth, height: headerHeight + viewHeight - navigationBarHeight)
    baseScrollView.contentInsetAdjustmentBehavior = .never
    baseScrollView.showsVerticalScrollIndicator = false
    baseScrollView.delegate = self
    view.addSubview(baseScrollView)

    headerView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: headerHeight)
    baseScrollView.addSubview(headerView)

    let circlePageViewFrame = CGRect(x: 0, y: headerView.frame.maxY, width: viewWidth, height: viewHeight - navigationBarHeight)
    let pageTitles = ["Home", "Hot"]
    let vc1 = CircleContentFeedViewController()
    vc1.baseScrollableCallback = { [weak self] (isScrollable) in
      self?.baseScrollViewScrollable = isScrollable
    }
    let vc2 = CircleContentFeedViewController()
    vc2.baseScrollableCallback = { [weak self] (isScrollable) in
      self?.baseScrollViewScrollable = isScrollable
    }
    let children = [vc1, vc2]
    pageView =
        CirclePageView(frame: circlePageViewFrame, pageTitles: pageTitles, childViewControllers: children, parentViewController: self)
    baseScrollView.addSubview(pageView!)
  }

  private func configureConstraints() {
    blurView.translatesAutoresizingMaskIntoConstraints = false
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    baseScrollView.translatesAutoresizingMaskIntoConstraints = false

    let constraints = [
      blurView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor),
      blurView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
      blurView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
      blurView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),

      backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
      backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      backgroundImageView.heightAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: 1.5),

      baseScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      baseScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      baseScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      baseScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - UIScrollViewDelegate

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y > headerView.titleMaxY && navigationItem.titleView == nil {
      navigationItem.titleView = navigationTitleView
    } else if scrollView.contentOffset.y <= headerView.titleMaxY && navigationItem.titleView != nil {
      navigationItem.titleView = nil
    }
    guard let currChild = pageView?.currentChildViewController else { return }
    let headerViewHeight = headerView.bounds.height
    if !baseScrollViewScrollable {
      scrollView.contentOffset.y = headerViewHeight
      currChild.contentScrollable = true
    } else if scrollView.contentOffset.y >= headerViewHeight {
      scrollView.contentOffset.y = headerViewHeight
      baseScrollViewScrollable = false
      currChild.contentScrollable = true
    }
  }

}

// MARK: - MultiResponseScrollView -

private class MultiResponseScrollView: UIScrollView, UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}

// MARK: - CircleNavigationTitleView -

private class CircleNavigationTitleView: UIView {

  private let imageView = UIImageView()

  private let titleLabel = UILabel()

  var image: UIImage? {
    didSet {
      imageView.image = image
    }
  }

  var title: String? {
    didSet {
      titleLabel.text = title
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    configureSubviews()
    configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configureSubviews() {
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = CornerRadius.small.rawValue
    imageView.layer.masksToBounds = true
    addSubview(imageView)

    titleLabel.font = CrowsFont.contentTitle
    titleLabel.textColor = CrowsColor.white.light
    addSubview(titleLabel)
  }

  private func configureConstraints() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    let constraints = [
      imageView.topAnchor.constraint(equalTo: topAnchor, constant: VerticalPadding.medium.rawValue),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -VerticalPadding.medium.rawValue),
      imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),

      titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: HorizontalPadding.medium.rawValue),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }

}
