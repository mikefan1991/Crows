//
//  ForwardContentCell.swift
//  Crows
//
//  Created by Yingwei Fan on 4/10/21.
//

import UIKit

// Constants
private let AuthorAvatarWidth: CGFloat = 20.0

class CreateContentForwardCell: UITableViewCell {

  private let titleLabel = UILabel()

  private let authorAvatarView = UIImageView()

  private let authorInfoLabel = UILabel()

  private let contentLabel = UILabel()

  private var contentImageView = UIImageView()

  private let cardBackgroundView = UIView()

  private var contentImageViewWidthConstraint: NSLayoutConstraint!

  var object: BaseContentObject? {
    didSet {
      guard let object = object else { return }
      titleLabel.text = object.title
      authorAvatarView.sd_setImage(with: URL(string: object.author.avatarURL ?? ""),
                                   placeholderImage: UIImage(systemName: "person.crop.circle.fill"))
      authorInfoLabel.text = object.author.nickname
      contentLabel.text = object.contentText
      if let imageURLs = object.imageURLs,
         let imageURL = imageURLs.first {
        contentImageView.isHidden = false
        contentImageViewWidthConstraint.isActive = true
        contentImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: CrowsImage.placeholder)
      }
    }
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    configureSubviews()
    configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
      cardBackgroundView.layer.borderColor = CrowsColor.grey650.cgColor
    }
  }

  // MARK: - Private

  private func configureSubviews() {
    titleLabel.font = CrowsFont.contentTitle
    titleLabel.numberOfLines = 2
    cardBackgroundView.addSubview(titleLabel)

    authorAvatarView.tintColor = .darkGray
    cardBackgroundView.addSubview(authorAvatarView)

    authorInfoLabel.font = CrowsFont.boldText
    authorInfoLabel.numberOfLines = 1
    authorInfoLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    cardBackgroundView.addSubview(authorInfoLabel)

    contentLabel.font = CrowsFont.text
    contentLabel.textColor = .darkGray
    contentLabel.numberOfLines = 2
    contentLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    cardBackgroundView.addSubview(contentLabel)

    contentImageView.isHidden = true
    contentImageView.contentMode = .scaleAspectFill
    contentImageView.clipsToBounds = true
    contentImageView.tintColor = CrowsColor.grey800
    contentImageView.layer.cornerRadius = CornerRadius.medium.rawValue
    contentImageView.layer.masksToBounds = true
    cardBackgroundView.addSubview(contentImageView)

    cardBackgroundView.backgroundColor = .lightGray
    cardBackgroundView.layer.cornerRadius = CornerRadius.medium.rawValue
    cardBackgroundView.layer.borderWidth = 2.0
    cardBackgroundView.layer.borderColor = CrowsColor.grey650.cgColor
    cardBackgroundView.layer.masksToBounds = true
    contentView.addSubview(cardBackgroundView)
  }

  private func configureConstraints() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    authorAvatarView.translatesAutoresizingMaskIntoConstraints = false
    authorInfoLabel.translatesAutoresizingMaskIntoConstraints = false
    contentLabel.translatesAutoresizingMaskIntoConstraints = false
    contentImageView.translatesAutoresizingMaskIntoConstraints = false
    cardBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    contentImageViewWidthConstraint = contentImageView.widthAnchor.constraint(equalTo: cardBackgroundView.widthAnchor, multiplier: 1.0/4)

    let contentViewMarginsGuide = contentView.layoutMarginsGuide
    let cardMarginsGuide = cardBackgroundView.layoutMarginsGuide
    let constraints = [
      titleLabel.topAnchor.constraint(equalTo: cardMarginsGuide.topAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: cardMarginsGuide.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: cardMarginsGuide.trailingAnchor),

      authorAvatarView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: VerticalPadding.small.rawValue),
      authorAvatarView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      authorAvatarView.widthAnchor.constraint(equalToConstant: AuthorAvatarWidth),
      authorAvatarView.heightAnchor.constraint(equalTo: authorAvatarView.widthAnchor),

      authorInfoLabel.topAnchor.constraint(equalTo: authorAvatarView.topAnchor),
      authorInfoLabel.leadingAnchor.constraint(equalTo: authorAvatarView.trailingAnchor, constant: HorizontalPadding.small.rawValue),
      authorInfoLabel.trailingAnchor.constraint(equalTo: contentImageView.leadingAnchor, constant: -HorizontalPadding.small.rawValue),
      authorInfoLabel.heightAnchor.constraint(equalTo: authorAvatarView.heightAnchor),

      contentLabel.topAnchor.constraint(equalTo: authorAvatarView.bottomAnchor, constant: VerticalPadding.small.rawValue),
      contentLabel.leadingAnchor.constraint(equalTo: authorAvatarView.leadingAnchor),
      contentLabel.trailingAnchor.constraint(equalTo: authorInfoLabel.trailingAnchor),
      contentLabel.bottomAnchor.constraint(equalTo: cardMarginsGuide.bottomAnchor),

      contentImageView.topAnchor.constraint(equalTo: authorAvatarView.topAnchor),
      contentImageView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      contentImageView.heightAnchor.constraint(equalTo: contentImageView.widthAnchor, multiplier: 2.0/3),

      cardBackgroundView.topAnchor.constraint(equalTo: contentViewMarginsGuide.topAnchor),
      cardBackgroundView.leadingAnchor.constraint(equalTo: contentViewMarginsGuide.leadingAnchor),
      cardBackgroundView.trailingAnchor.constraint(equalTo: contentViewMarginsGuide.trailingAnchor),
      cardBackgroundView.bottomAnchor.constraint(equalTo: contentViewMarginsGuide.bottomAnchor)
    ]

    NSLayoutConstraint.activate(constraints)
  }

}
