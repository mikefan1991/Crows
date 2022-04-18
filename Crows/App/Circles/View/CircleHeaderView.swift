//
//  CircleTableHeaderView.swift
//  Crows
//
//  Created by Yingwei Fan on 4/13/21.
//

import UIKit

private let AvatarImageViewWidth: CGFloat = 40.0
private let JoinButtonWidth: CGFloat = 80.0
private let JoinButtonHeight: CGFloat = 30.0

class CircleHeaderView: UIView {

  private let avatarImageView = UIImageView()

  private let titleLabel = UILabel()

  private let descriptionLabel = UILabel()

  private let joinButton = AnimationButton()

  var titleMaxY: CGFloat {
    return titleLabel.frame.maxY
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    configureSubviews()
    configureCosntraints()
    testData()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    let availableSize = CGSize(width: size.width - HorizontalPadding.standard.rawValue * 2, height: size.height)
    let paddingHeight = VerticalPadding.standard.rawValue * 2 + VerticalPadding.medium.rawValue
    let avatarHeight = AvatarImageViewWidth
    let descriptionHeight = descriptionLabel.sizeThatFits(availableSize).height
    return CGSize(width: availableSize.width, height:paddingHeight + avatarHeight + descriptionHeight)
  }

  private func testData() {
    avatarImageView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "CircleTemplate"))
    titleLabel.text = "Big circle"
    descriptionLabel.text = "Join our big circle now! Join our big circle now! Join our big circle now!"
  }

  // MARK: - Private

  private func configureSubviews() {
    avatarImageView.contentMode = .scaleAspectFill
    avatarImageView.clipsToBounds = true
    avatarImageView.layer.cornerRadius = CornerRadius.small.rawValue
    avatarImageView.layer.masksToBounds = true
    addSubview(avatarImageView)

    titleLabel.font = CrowsFont.contentTitle
    titleLabel.textColor = CrowsColor.white.light
    titleLabel.numberOfLines = 3
    addSubview(titleLabel)

    descriptionLabel.font = CrowsFont.caption
    descriptionLabel.textColor = CrowsColor.white.light
    descriptionLabel.numberOfLines = 3
    addSubview(descriptionLabel)

    joinButton.setImage(UIImage(systemName: "plus"), for: .normal)
    joinButton.tintColor = CrowsColor.grey900.light
    joinButton.setTitle(" " + NSLocalizedString("Join", comment: ""), for: .normal)
    joinButton.setTitleColor(CrowsColor.grey900.light, for: .normal)
    joinButton.titleLabel?.font = CrowsFont.buttonSmall
    joinButton.backgroundColor = CrowsColor.white.light
    joinButton.layer.cornerRadius = JoinButtonHeight / 2
    joinButton.layer.masksToBounds = true
    addSubview(joinButton)
  }

  private func configureCosntraints() {
    avatarImageView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    joinButton.translatesAutoresizingMaskIntoConstraints = false

    let constraints = [
      avatarImageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
      avatarImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      avatarImageView.widthAnchor.constraint(equalToConstant: AvatarImageViewWidth),
      avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

      titleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: HorizontalPadding.standard.rawValue),
      titleLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: joinButton.leadingAnchor, constant: -HorizontalPadding.standard.rawValue),

      joinButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
      joinButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
      joinButton.widthAnchor.constraint(equalToConstant: JoinButtonWidth),
      joinButton.heightAnchor.constraint(equalToConstant: JoinButtonHeight),

      descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: VerticalPadding.medium.rawValue),
      descriptionLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
      descriptionLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
    ]
    NSLayoutConstraint.activate(constraints)
  }

}
