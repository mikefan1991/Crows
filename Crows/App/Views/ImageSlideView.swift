//
//  ImageRotationView.swift
//  Crows
//
//  Created by Yingwei Fan on 4/4/21.
//

import UIKit

private let CellReuseIdentifier = "ImageSlideCell"
private let PageControlHeight: CGFloat = 35.0
private let MaxNumberOfSections = 7

class ImageSlideView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  lazy private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

  lazy private var flowLayout: UICollectionViewFlowLayout = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumLineSpacing = 0
    flowLayout.minimumInteritemSpacing = 0
    flowLayout.scrollDirection = .horizontal
    return flowLayout
  }()

  private let pageControl = UIPageControl()

  // This gradient layer is for the page control.
  private let gradientLayer = CAGradientLayer()

  private var shouldEnableScroll: Bool {
    guard let imageURLs = imageURLs else { return false }
    return imageURLs.count > 1
  }

  private var initialScrollDone = false

  var imageURLs: [String]? {
    didSet {
      guard let imageURLs  = imageURLs, imageURLs.count > 0 else { return }
      pageControl.numberOfPages = imageURLs.count
      collectionView.isScrollEnabled = shouldEnableScroll
      collectionView.reloadData()
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

  override func layoutSubviews() {
    super.layoutSubviews()

    gradientLayer.frame = pageControl.bounds
    if !initialScrollDone, shouldEnableScroll {
      collectionView.scrollToItem(at: IndexPath(item: 0, section: MaxNumberOfSections / 2),
                                  at: .centeredHorizontally,
                                  animated: false)
      initialScrollDone = true
    }
  }

  override var intrinsicContentSize: CGSize {
    return CGSize(width: 75.0, height: 50.0)
  }

  // MARK: - Private

  private func configureSubviews() {
    collectionView.backgroundColor = .clear
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.isPagingEnabled = true
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(ImageSlideCell.self, forCellWithReuseIdentifier: CellReuseIdentifier)
    addSubview(collectionView)

    pageControl.numberOfPages = imageURLs?.count ?? 0
    pageControl.hidesForSinglePage = true
    pageControl.isUserInteractionEnabled = false
    gradientLayer.colors = [UIColor.lightGray.cgColor,
                            UIColor.lightGray.withAlphaComponent(0.6).cgColor,
                            UIColor.lightGray.withAlphaComponent(0).cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
    pageControl.layer.insertSublayer(gradientLayer, at: 0)
    addSubview(pageControl)
  }

  private func configureConstraints() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    pageControl.translatesAutoresizingMaskIntoConstraints = false

    let constraints = [
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),

      pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
      pageControl.trailingAnchor.constraint(equalTo: trailingAnchor),
      pageControl.bottomAnchor.constraint(equalTo: bottomAnchor),
      pageControl.heightAnchor.constraint(equalToConstant: PageControlHeight)
    ]

    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - UICollectionViewDataSource

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    guard let _ = imageURLs else { return 0 }
    return shouldEnableScroll ? MaxNumberOfSections : 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let imageURLs = imageURLs else { return 0 }
    return imageURLs.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellReuseIdentifier, for: indexPath) as? ImageSlideCell,
          let imageURLs = imageURLs else {
      return ImageSlideCell()
    }

    cell.imageURL = imageURLs[indexPath.item]

    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return collectionView.bounds.size
  }

  // MARK: - UIScrollViewDelegate

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let imageURLs = imageURLs, shouldEnableScroll else {
      return
    }
    let currOffsetX = scrollView.contentOffset.x
    let cellWidth = scrollView.bounds.width
    let currPage = Int(round(currOffsetX / cellWidth)) % imageURLs.count
    pageControl.currentPage = currPage
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    collectionView.scrollToItem(at: IndexPath(item: pageControl.currentPage, section: MaxNumberOfSections / 2),
                                at: .centeredHorizontally,
                                animated: false)
  }
}

// MARK: - ImageSlideCell -

private class ImageSlideCell: UICollectionViewCell {
  private let imageView = UIImageView()

  var imageURL: String? {
    didSet {
      guard let imageURL = imageURL else { return }
      imageView.sd_setImage(with: URL(string: imageURL), placeholderImage: CrowsImage.placeholder)
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    contentView.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    imageView.image = nil
  }
}
