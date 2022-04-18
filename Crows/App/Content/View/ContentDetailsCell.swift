//
//  ContentDetailsCell.swift
//  Crows
//
//  Created by Yingwei Fan on 4/4/21.
//

import UIKit

// Constants
private let AuthorAvatarWidth: CGFloat = 30.0

class ContentDetailsCell: UITableViewCell {

  private let stackView = UIStackView()

  private let titleLabel = UILabel()

  private let authorStackView = UIStackView()

  private let authorAvatarView = UIImageView()

  private let authorInfoLabel = UILabel()

  private let imageSlideView = ImageSlideView()

  private let youtubePlayerView = CrowsYouTubePlayerView()

  private let contentLabel = UILabel()

  private let createTimeLabel = UILabel()

  var object: ContentDetailsObject? {
    didSet {
      titleLabel.text = object?.title
      let author = object?.author
      authorAvatarView.sd_setImage(with: URL(string: author?.avatarURL ?? ""), placeholderImage: UIImage(systemName: "person.circle"))
      authorInfoLabel.text = author?.username
      if let nickname = author?.nickname, !nickname.isEmpty {
        authorInfoLabel.text = nickname
      }
      if let youtubeID = object?.youtubeID {
        youtubePlayerView.isHidden = false
        youtubePlayerView.loadVideoID(youtubeID)
      } else if let imageURLs = object?.imageURLs, !imageURLs.isEmpty {
        imageSlideView.isHidden = false
        imageSlideView.imageURLs = imageURLs
      }
      contentLabel.text = object?.text
      createTimeLabel.text = object?.createdTime
    }
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    backgroundColor = .clear
    configureSubviews()
    configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private

  private func configureSubviews() {
    // Title
    titleLabel.font = CrowsFont.contentTitle
    titleLabel.textColor = CrowsColor.grey900
    titleLabel.numberOfLines = 2
    stackView.addArrangedSubview(titleLabel)

    // Author
    authorAvatarView.tintColor = CrowsColor.grey800
    authorAvatarView.contentMode = .scaleAspectFill
    authorAvatarView.layer.cornerRadius = AuthorAvatarWidth / 2.0
    authorAvatarView.layer.masksToBounds = true
    authorStackView.addArrangedSubview(authorAvatarView)

    authorInfoLabel.font = CrowsFont.boldText
    authorInfoLabel.textColor = CrowsColor.grey800
    authorInfoLabel.numberOfLines = 1
    authorStackView.addArrangedSubview(authorInfoLabel)

    authorStackView.spacing = HorizontalPadding.small.rawValue
    stackView.addArrangedSubview(authorStackView)

    // Image slider
    imageSlideView.isHidden = true
    stackView.addArrangedSubview(imageSlideView)

    // YouTube player view
    youtubePlayerView.isHidden = true
    stackView.addArrangedSubview(youtubePlayerView)

    // Article body
    contentLabel.font = CrowsFont.text
    contentLabel.textColor = CrowsColor.grey800
    contentLabel.numberOfLines = 0
    stackView.addArrangedSubview(contentLabel)

    // Create time
    createTimeLabel.font = CrowsFont.caption
    createTimeLabel.textColor = CrowsColor.grey650
    stackView.addArrangedSubview(createTimeLabel)

    stackView.axis = .vertical
    stackView.spacing = VerticalPadding.medium.rawValue
    contentView.addSubview(stackView)
  }

  private func configureConstraints() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    authorStackView.translatesAutoresizingMaskIntoConstraints = false
    authorAvatarView.translatesAutoresizingMaskIntoConstraints = false
    authorInfoLabel.translatesAutoresizingMaskIntoConstraints = false
    imageSlideView.translatesAutoresizingMaskIntoConstraints = false
    youtubePlayerView.translatesAutoresizingMaskIntoConstraints = false
    contentLabel.translatesAutoresizingMaskIntoConstraints = false
    createTimeLabel.translatesAutoresizingMaskIntoConstraints = false

    let marginsGuide = contentView.layoutMarginsGuide
    let constraints = [
      stackView.topAnchor.constraint(equalTo: marginsGuide.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: marginsGuide.bottomAnchor),

      authorAvatarView.widthAnchor.constraint(equalToConstant: AuthorAvatarWidth),
      authorAvatarView.heightAnchor.constraint(equalTo: authorAvatarView.widthAnchor),

      imageSlideView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 2.0/3),

      youtubePlayerView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 9.0/16)
    ]

    NSLayoutConstraint.activate(constraints)
  }

}
