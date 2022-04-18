//
//  BaseContentCell.swift
//  Crows
//
//  Created by Yingwei Fan on 4/3/21.
//

import UIKit
import SDWebImage
import YouTubePlayer

// Constants
private let AuthorAvatarWidth: CGFloat = 30.0
private let InfoBarHeight: CGFloat = 30.0

class BaseContentCell: UITableViewCell {

  static let reuseIdentifier = "BaseContentCell"

  private let stackView = UIStackView()
  // This stack view contains user information and content text.
  private let subVerticalStackView = UIStackView()
  // This stack view contains the subVerticalStackView and image.
  private let subHorizontalStackView = UIStackView()

  private let titleLabel = UILabel()

  private let authorView = AuthorView()

  private let contentTextLabel = UILabel()

  private var contentImageView = UIImageView()

  private let youtubePlayerView = CrowsYouTubePlayerView()

  private let infoBar = UILabel()

  var object: BaseContentObject? {
    didSet {
      guard let object = object else { return }
      titleLabel.text = object.title
      authorView.avatarURL = object.author.avatarURL
      var authorInfo = object.author.username
      if let nickname = object.author.nickname, !nickname.isEmpty {
        authorInfo = nickname
      }
      authorView.authorInfo = authorInfo
      contentTextLabel.text = object.contentText
      if let youtubeID = object.youtubeID {
        youtubePlayerView.isHidden = false
        youtubePlayerView.loadVideoID(youtubeID)
      } else if let imageURLs = object.imageURLs, let imageURL = imageURLs.first {
        contentImageView.isHidden = false
        contentImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: CrowsImage.placeholder)
      }
      infoBar.text = object.status
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

  override func prepareForReuse() {
    titleLabel.text = nil
    authorView.avatarURL = nil
    authorView.authorInfo = nil
    contentTextLabel.text = nil
    if !contentImageView.isHidden {
      contentImageView.image = nil
      contentImageView.isHidden = true
    }
    if !youtubePlayerView.isHidden {
      youtubePlayerView.clear()
      youtubePlayerView.isHidden = true
    }
  }

  // MARK: - Private

  private func configureSubviews() {
    stackView.axis = .vertical
    stackView.spacing = VerticalPadding.medium.rawValue
    contentView.addSubview(stackView)

    titleLabel.font = CrowsFont.contentTitle
    titleLabel.textColor = CrowsColor.grey900
    titleLabel.numberOfLines = 2
    stackView.addArrangedSubview(titleLabel)

    subVerticalStackView.axis = .vertical
    subVerticalStackView.spacing = VerticalPadding.medium.rawValue
    subVerticalStackView.addArrangedSubview(authorView)
    contentTextLabel.font = CrowsFont.text
    contentTextLabel.textColor = CrowsColor.grey800
    contentTextLabel.numberOfLines = 2
    subVerticalStackView.addArrangedSubview(contentTextLabel)

    subHorizontalStackView.axis = .horizontal
    subHorizontalStackView.alignment = .center
    subHorizontalStackView.spacing = HorizontalPadding.medium.rawValue
    subHorizontalStackView.addArrangedSubview(subVerticalStackView)
    contentImageView.isHidden = true
    contentImageView.contentMode = .scaleAspectFill
    contentImageView.clipsToBounds = true
    contentImageView.tintColor = CrowsColor.grey800
    subHorizontalStackView.addArrangedSubview(contentImageView)
    stackView.addArrangedSubview(subHorizontalStackView)

    youtubePlayerView.isHidden = true
    stackView.addArrangedSubview(youtubePlayerView)

    infoBar.font = CrowsFont.caption
    infoBar.textColor = CrowsColor.grey650
    stackView.addArrangedSubview(infoBar)
  }

  private func configureConstraints() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    subVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
    subHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    contentTextLabel.translatesAutoresizingMaskIntoConstraints = false
    contentImageView.translatesAutoresizingMaskIntoConstraints = false
    youtubePlayerView.translatesAutoresizingMaskIntoConstraints = false
    infoBar.translatesAutoresizingMaskIntoConstraints = false

    let marginsGuide = contentView.layoutMarginsGuide
    let constraints = [
      stackView.topAnchor.constraint(equalTo: marginsGuide.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: marginsGuide.bottomAnchor),

      contentImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.1/4),
      contentImageView.heightAnchor.constraint(equalTo: contentImageView.widthAnchor, multiplier: 2.0/3),

      youtubePlayerView.heightAnchor.constraint(equalTo: youtubePlayerView.widthAnchor, multiplier: 9.0/16),

      infoBar.heightAnchor.constraint(equalToConstant: InfoBarHeight)
    ]

    NSLayoutConstraint.activate(constraints)
  }

}

// MARK: - AuthorView -

private class AuthorView: UIView {

  private let stackView = UIStackView()

  private let avatarView = UIImageView()

  private let infoLabel = UILabel()

  var avatarURL: String? {
    didSet {
      avatarView.sd_setImage(with: URL(string: avatarURL ?? ""), placeholderImage: UIImage(systemName: "person.crop.circle.fill"))
    }
  }

  var authorInfo: String? {
    didSet {
      infoLabel.text = authorInfo
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

  // MARK: - Private

  private func configureSubviews() {
    stackView.axis = .horizontal
    stackView.spacing = HorizontalPadding.medium.rawValue
    addSubview(stackView)

    avatarView.tintColor = CrowsColor.grey800
    avatarView.layer.cornerRadius = AuthorAvatarWidth / 2
    avatarView.layer.masksToBounds = true
    stackView.addArrangedSubview(avatarView)

    infoLabel.font = CrowsFont.boldCaption
    infoLabel.numberOfLines = 1
    stackView.addArrangedSubview(infoLabel)
  }

  private func configureConstraints() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    avatarView.translatesAutoresizingMaskIntoConstraints = false
    infoLabel.translatesAutoresizingMaskIntoConstraints = false

    let constraints = [
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

      avatarView.widthAnchor.constraint(equalToConstant: AuthorAvatarWidth),
      avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }

}
