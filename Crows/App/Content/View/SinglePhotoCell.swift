//
//  SinglePhotoCell.swift
//  Crows
//
//  Created by Yingwei Fan on 4/11/21.
//

import UIKit

private let DeleteButtonWidth: CGFloat = 20.0

protocol SinglePhotoCellDelegate: NSObjectProtocol {
  func singlePhotoCellDidTapDelete(_ cell: SinglePhotoCell)
}

class SinglePhotoCell: UICollectionViewCell {

  static let reuseIdentifier = "SinglePhotoCell"

  private let imageView = UIImageView()

  private let deleteButton = UIButton()

  private var imageViewHalfWidthConstraint: NSLayoutConstraint!
  private var imageViewFullWidthConstraint: NSLayoutConstraint!

  var image: UIImage? {
    didSet {
      guard let image = image else {
        imageView.image = UIImage(systemName: "plus")
        imageViewFullWidthConstraint.isActive = false
        deleteButton.isHidden = true
        return
      }
      imageView.image = image
      imageViewFullWidthConstraint.isActive = true
      deleteButton.isHidden = false
    }
  }

  weak var delegate: SinglePhotoCellDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)

    configureSubviews()
    configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    image = nil
  }

  // MARK: - Private

  private func configureSubviews() {
    contentView.backgroundColor = CrowsColor.grey650

    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.tintColor = CrowsColor.white
    imageView.image = UIImage(systemName: "plus")
    contentView.addSubview(imageView)

    deleteButton.isHidden = true
    deleteButton.tintColor = .systemRed
    deleteButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
    deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
    contentView.addSubview(deleteButton)
  }

  private func configureConstraints() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    deleteButton.translatesAutoresizingMaskIntoConstraints = false
    imageViewHalfWidthConstraint = imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.0/3)
    imageViewHalfWidthConstraint.priority = .defaultHigh
    imageViewFullWidthConstraint = imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor)

    let constraints = [
      imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
      imageViewHalfWidthConstraint!,

      deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: VerticalPadding.small.rawValue),
      deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HorizontalPadding.small.rawValue),
      deleteButton.widthAnchor.constraint(equalToConstant: DeleteButtonWidth),
      deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - Actions

  @objc private func didTapDeleteButton() {
    delegate?.singlePhotoCellDidTapDelete(self)
  }

}

