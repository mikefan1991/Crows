//
//  HobbyCell.swift
//  Crows
//
//  Created by Yingwei Fan on 4/8/21.
//

import UIKit

private let CheckmarkWidth: CGFloat = 20.0

class HobbyCell: UICollectionViewCell {

  private let imageView = UIImageView()

  private let titleLabel = UILabel()

  private let selectedBorder = UIView()

  var hobbyName: String? {
    didSet {
      titleLabel.text = hobbyName
    }
  }

  var hobbyImage: UIImage? {
    didSet {
      imageView.image = hobbyImage
    }
  }

  var isHobbySelected = false {
    didSet {
      selectedBorder.isHidden = !isHobbySelected
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    contentView.addSubview(imageView)

    titleLabel.backgroundColor = UIColor(white: 0.2, alpha: 0.6)
    titleLabel.font = CrowsFont.contentTitle
    titleLabel.textAlignment = .center
    titleLabel.textColor = .white
    titleLabel.numberOfLines = 2
    titleLabel.lineBreakMode = .byWordWrapping
    contentView.addSubview(titleLabel)

    selectedBorder.isHidden = true
    selectedBorder.layer.cornerRadius = CornerRadius.medium.rawValue
    selectedBorder.layer.masksToBounds = true
    selectedBorder.layer.borderWidth = 3.0
    selectedBorder.layer.borderColor = CrowsColor.blue.light.cgColor
    contentView.addSubview(selectedBorder)

    layer.cornerRadius = CornerRadius.medium.rawValue
    layer.masksToBounds = true
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    imageView.frame = contentView.bounds
    titleLabel.frame = contentView.bounds
    selectedBorder.frame = contentView.bounds
  }

}
