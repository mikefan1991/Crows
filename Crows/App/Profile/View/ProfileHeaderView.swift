//
//  ProfileHeaderView.swift
//  Crows
//
//  Created by Yingwei Fan on 5/7/21.
//

import UIKit

private let AvatarImageViewWidth: CGFloat = 60.0

protocol ProfileHeaderViewDelegate: NSObjectProtocol {
  func profileHeaderView(_ profileHeaderView: ProfileHeaderView, didTap: UIImageView)
}

class ProfileHeaderView: UIView {

  private let avatarImageView = UIImageView()

  private let nameLabel = UILabel()

  private let editProfileButton = AnimationButton()

  var avatarURL: String? {
    didSet {
      avatarImageView.sd_setImage(with: URL(string: avatarURL ?? ""), placeholderImage: UIImage(named: "AvatarPlaceholder"))
    }
  }

  var name: String? {
    didSet {
      nameLabel.text = name
    }
  }

  weak var delegate: ProfileHeaderViewDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)

    configureSubviews()
    configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
      editProfileButton.layer.borderColor = CrowsColor.grey650.cgColor
    }
  }

  // MARK: - Public

  func setImage(_ image: UIImage?, with imageURL: String?) {
    avatarImageView.sd_setImage(with: URL(string: imageURL ?? ""), placeholderImage: image)
  }

  // MARK: - Private

  private func configureSubviews() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatarImageView))
    avatarImageView.addGestureRecognizer(tap)
    avatarImageView.isUserInteractionEnabled = true
    avatarImageView.contentMode = .scaleAspectFill
    avatarImageView.layer.cornerRadius = AvatarImageViewWidth / 2
    avatarImageView.layer.masksToBounds = true
    avatarImageView.sd_setImage(with: nil, placeholderImage: UIImage(named: "AvatarPlaceholder"))
    addSubview(avatarImageView)

    nameLabel.font = CrowsFont.contentTitle
    nameLabel.textColor = CrowsColor.grey900
    nameLabel.setContentHuggingPriority(.required, for: .vertical)
    addSubview(nameLabel)

    editProfileButton.tintColor = CrowsColor.blue
    editProfileButton.setImage(UIImage(systemName: "pencil"), for: .normal)
    editProfileButton.setTitle("  " + NSLocalizedString("Profile.Edit", comment: ""), for: .normal)
    editProfileButton.setTitleColor(CrowsColor.grey900, for: .normal)
    editProfileButton.titleLabel?.font = CrowsFont.buttonSmall
    editProfileButton.layer.cornerRadius = CornerRadius.small.rawValue
    editProfileButton.layer.masksToBounds = true
    editProfileButton.layer.borderWidth = 1.0
    editProfileButton.layer.borderColor = CrowsColor.grey650.cgColor
    addSubview(editProfileButton)
  }

  private func configureConstraints() {
    avatarImageView.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    editProfileButton.translatesAutoresizingMaskIntoConstraints = false

    let constraints = [
      avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: VerticalPadding.standard.rawValue),
      avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: HorizontalPadding.standard.rawValue),
      avatarImageView.widthAnchor.constraint(equalToConstant: AvatarImageViewWidth),
      avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

      nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: HorizontalPadding.standard.rawValue),
      nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -HorizontalPadding.standard.rawValue),

      editProfileButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: VerticalPadding.medium.rawValue),
      editProfileButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
      editProfileButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.35),
      editProfileButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - Actions

  @objc private func didTapAvatarImageView() {
    delegate?.profileHeaderView(self, didTap: avatarImageView)
  }

}
