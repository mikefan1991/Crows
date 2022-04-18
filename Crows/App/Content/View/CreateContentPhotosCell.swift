//
//  CreateContentPhotosCell.swift
//  Crows
//
//  Created by Yingwei Fan on 4/9/21.
//

import UIKit

private let MaxNumberOfPhotos = 9

protocol ContentPhotosCellDelegate: NSObjectProtocol {
  func createContentPhotosCellDidTapAddPhoto(_ cell: CreateContentPhotosCell)

  func createContentPhotosCell(_ cell: CreateContentPhotosCell, didRemovePhotoAt index: Int)
}

class CreateContentPhotosCell: UITableViewCell,
                         UICollectionViewDataSource,
                         UICollectionViewDelegate,
                         UICollectionViewDelegateFlowLayout,
                         SinglePhotoCellDelegate {

  static let collectionViewSpacing: CGFloat = 10.0

  lazy private var flowLayout: UICollectionViewFlowLayout = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumLineSpacing = CreateContentPhotosCell.collectionViewSpacing
    flowLayout.minimumInteritemSpacing = CreateContentPhotosCell.collectionViewSpacing
    flowLayout.scrollDirection = .vertical
    return flowLayout
  }()

  lazy private var collectionView: DynamicHeightCollectionView = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: flowLayout)

  var photos = [UIImage]()

  weak var delegate: ContentPhotosCellDelegate?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    backgroundColor = .clear
    configureSubviews()
    configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public

  func reloadAndRelayoutCollectionView() {
    collectionView.reloadData()
    collectionView.layoutIfNeeded()
  }

  // MARK: - Private

  private func configureSubviews() {
    collectionView.backgroundColor = .clear
    collectionView.isScrollEnabled = false
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(SinglePhotoCell.self, forCellWithReuseIdentifier: SinglePhotoCell.reuseIdentifier)
    contentView.addSubview(collectionView)
  }

  private func configureConstraints() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false

    let marginsGuide = contentView.layoutMarginsGuide
    let constraints = [
      collectionView.topAnchor.constraint(equalTo: marginsGuide.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: marginsGuide.bottomAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - UICollectionViewDataSource

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos.count == MaxNumberOfPhotos ? photos.count : photos.count + 1
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let singlePhotoCell =
        collectionView.dequeueReusableCell(withReuseIdentifier: SinglePhotoCell.reuseIdentifier, for: indexPath) as! SinglePhotoCell

    if indexPath.item != photos.count {
      singlePhotoCell.image = photos[indexPath.item]
      singlePhotoCell.delegate = self
    }

    return singlePhotoCell
  }

  // MARK: - UICollectionViewDeletegate

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.item == photos.count {
      delegate?.createContentPhotosCellDidTapAddPhoto(self)
    }
  }

  // MARK: - UICollectionViewDelegateFlowLayout

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.bounds.width - CreateContentPhotosCell.collectionViewSpacing * 2) / 3
    return CGSize(width: width, height: width)
  }

  // MARK: - SinglePhotoCellDelegate

  func singlePhotoCellDidTapDelete(_ cell: SinglePhotoCell) {
    guard let indexPath = collectionView.indexPath(for: cell) else { return }
    collectionView.performBatchUpdates {
      photos.remove(at: indexPath.item)
      collectionView.deleteItems(at: [indexPath])
      if photos.count == MaxNumberOfPhotos - 1 {
        collectionView.insertItems(at: [IndexPath(item: photos.count, section: 0)])
      }
    } completion: { [weak self] _ in
      guard let strongSelf = self else { return }
      strongSelf.delegate?.createContentPhotosCell(strongSelf, didRemovePhotoAt: indexPath.item)
    }
  }

}

