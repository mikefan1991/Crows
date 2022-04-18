//
//  CommentCell.swift
//  Crows
//
//  Created by Yingwei Fan on 4/5/21.
//

import UIKit

private let AuthorAvatarWidth: CGFloat = 30.0

class CommentCell: UITableViewCell {

  private let authorAvatarView = UIImageView()

  private let authorNameLabel = UILabel()

  private let contentLabel = UILabel()

  private let likeCountLabel = UILabel()

  private let likeButton = AnimationButton()

  var object: ContentCommentObject? {
    didSet {
      authorAvatarView.sd_setImage(with: URL(string: object?.author.avatarURL ?? ""),
                                   placeholderImage: UIImage(systemName: "person.circle"))
      authorNameLabel.text = object?.author.username
      if let nickname = object?.author.nickname {
        authorNameLabel.text = nickname
      }
      contentLabel.text = object?.text
      if let likeCount = object?.likeCount {
        likeCountLabel.text = likeCount == 0 ? nil : String(likeCount)
      }
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
    authorAvatarView.tintColor = CrowsColor.grey800
    authorAvatarView.contentMode = .scaleAspectFill
    authorAvatarView.layer.cornerRadius = AuthorAvatarWidth / 2.0
    authorAvatarView.layer.masksToBounds = true
    contentView.addSubview(authorAvatarView)

    authorNameLabel.numberOfLines = 1
    authorNameLabel.font = CrowsFont.caption
    authorNameLabel.textColor = CrowsColor.grey800
    contentView.addSubview(authorNameLabel)

    contentLabel.numberOfLines = 0
    contentLabel.font = CrowsFont.text
    contentLabel.textColor = CrowsColor.grey800
    contentView.addSubview(contentLabel)

    likeCountLabel.font = CrowsFont.buttonSmall
    likeCountLabel.textColor = CrowsColor.grey650
    likeCountLabel.setContentHuggingPriority(.required, for: .horizontal)
    likeCountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    contentView.addSubview(likeCountLabel)

    likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
    likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .selected)
    likeButton.tintColor = CrowsColor.blue
    likeButton.addTarget(self, action: #selector(didTapLikeButton(_:)), for: .touchUpInside)
    contentView.addSubview(likeButton)
  }

  private func configureConstraints() {
    authorAvatarView.translatesAutoresizingMaskIntoConstraints = false
    authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
    contentLabel.translatesAutoresizingMaskIntoConstraints = false
    likeCountLabel.translatesAutoresizingMaskIntoConstraints = false
    likeButton.translatesAutoresizingMaskIntoConstraints = false

    let marginsGuide = contentView.layoutMarginsGuide
    let constraints = [
      authorAvatarView.topAnchor.constraint(equalTo: marginsGuide.topAnchor),
      authorAvatarView.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor),
      authorAvatarView.widthAnchor.constraint(equalToConstant: AuthorAvatarWidth),
      authorAvatarView.heightAnchor.constraint(equalTo: authorAvatarView.widthAnchor),

      authorNameLabel.centerYAnchor.constraint(equalTo: authorAvatarView.centerYAnchor),
      authorNameLabel.leadingAnchor.constraint(equalTo: authorAvatarView.trailingAnchor, constant: HorizontalPadding.small.rawValue),
      authorNameLabel.trailingAnchor.constraint(equalTo: likeCountLabel.leadingAnchor, constant: -HorizontalPadding.small.rawValue),

      contentLabel.topAnchor.constraint(equalTo: authorAvatarView.bottomAnchor, constant: VerticalPadding.small.rawValue),
      contentLabel.leadingAnchor.constraint(equalTo: authorNameLabel.leadingAnchor),
      contentLabel.trailingAnchor.constraint(equalTo: authorNameLabel.trailingAnchor),
      contentLabel.bottomAnchor.constraint(equalTo: marginsGuide.bottomAnchor),

      likeCountLabel.centerYAnchor.constraint(equalTo: authorNameLabel.centerYAnchor),
      likeCountLabel.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -HorizontalPadding.small.rawValue),

      likeButton.centerYAnchor.constraint(equalTo: authorNameLabel.centerYAnchor),
      likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HorizontalPadding.medium.rawValue),
      likeButton.widthAnchor.constraint(equalToConstant: 30),
      likeButton.heightAnchor.constraint(equalTo: likeButton.widthAnchor)
    ]

    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - Actions

  @objc private func didTapLikeButton(_ button: UIButton) {
    button.isSelected = !button.isSelected
    if button.isSelected {
      if let object = object {
        object.likeCount += 1
        likeCountLabel.text = "\(object.likeCount)"
      }
    } else {
      if let object = object {
        object.likeCount -= 1
        likeCountLabel.text = "\(object.likeCount)"
      }
    }
  }

}
