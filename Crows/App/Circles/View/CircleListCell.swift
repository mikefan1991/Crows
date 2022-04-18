//
//  CircleListCell.swift
//  Crows
//
//  Created by Yingwei Fan on 4/18/21.
//

import UIKit

private let AvatarImageViewWidth: CGFloat = 40.0
private let ActionButtonWidth: CGFloat = 50.0
private let ActionButtonHeight: CGFloat = 25.0

class CircleListCell: UITableViewCell {

  static let reuseIdentifier = "CircleListCell"

  private let avatarImageView = UIImageView()

  private let titleLabel = UILabel()

  private let subtitleLabel = UILabel()

  private let actionButton = AnimationButton()

  private let descriptionLabel = UILabel()

  var shouldShowSelect = false {
    didSet {
      let title = shouldShowSelect ? NSLocalizedString("Select", comment: "") : NSLocalizedString("Join", comment: "")
      actionButton.setTitle(title, for: .normal)
    }
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    backgroundColor = .clear
    configureSubviews()
    configureConstraints()
    testData()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func testData() {
    avatarImageView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "CircleTemplate"))
    titleLabel.text = "Our very beautiful circle"
    subtitleLabel.text = "Over 10 thousands members"
    descriptionLabel.text = "This is an awesome circle!"
  }

  // MARK: - Private

  private func configureSubviews() {
    avatarImageView.contentMode = .scaleAspectFill
    avatarImageView.clipsToBounds = true
    avatarImageView.layer.cornerRadius = CornerRadius.small.rawValue
    avatarImageView.layer.masksToBounds = true
    contentView.addSubview(avatarImageView)

    titleLabel.font = CrowsFont.boldText
    titleLabel.textColor = CrowsColor.grey900
    titleLabel.numberOfLines = 1
    contentView.addSubview(titleLabel)

    subtitleLabel.font = CrowsFont.caption
    subtitleLabel.textColor = CrowsColor.grey650
    subtitleLabel.numberOfLines = 1
    contentView.addSubview(subtitleLabel)

    actionButton.backgroundColor = .orange
    actionButton.setTitleColor(CrowsColor.grey900, for: .normal)
    actionButton.setTitle(NSLocalizedString("Join", comment: ""), for: .normal)
    actionButton.titleLabel?.font = CrowsFont.buttonSmall
    actionButton.layer.cornerRadius = ActionButtonHeight / 2
    actionButton.layer.masksToBounds = true
    actionButton.addTarget(self, action: #selector(didTapActionButton(_:)), for: .touchUpInside)
    contentView.addSubview(actionButton)

    descriptionLabel.font = CrowsFont.text
    descriptionLabel.textColor = CrowsColor.grey800
    descriptionLabel.numberOfLines = 3
    contentView.addSubview(descriptionLabel)
  }

  private func configureConstraints() {
    avatarImageView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    actionButton.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

    let marginsGuide = contentView.layoutMarginsGuide
    let constraints = [
      avatarImageView.topAnchor.constraint(equalTo: marginsGuide.topAnchor),
      avatarImageView.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor),
      avatarImageView.widthAnchor.constraint(equalToConstant: AvatarImageViewWidth),
      avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

      titleLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: HorizontalPadding.medium.rawValue),
      titleLabel.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -HorizontalPadding.small.rawValue),

      subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      subtitleLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
      subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

      actionButton.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor),
      actionButton.widthAnchor.constraint(equalToConstant: ActionButtonWidth),
      actionButton.heightAnchor.constraint(equalToConstant: ActionButtonHeight),
      actionButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),

      descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: VerticalPadding.medium.rawValue),
      descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: actionButton.trailingAnchor),
      descriptionLabel.bottomAnchor.constraint(equalTo: marginsGuide.bottomAnchor)
    ]

    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - Actions

  @objc private func didTapActionButton(_ button: UIButton) {

  }

}
