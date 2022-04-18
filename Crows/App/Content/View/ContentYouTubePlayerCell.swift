//
//  ContentYouTubePlayerCell.swift
//  Crows
//
//  Created by Yingwei Fan on 4/21/21.
//

import UIKit
import YouTubePlayer

private let DeleteButtonPadding: CGFloat = 10.0
private let DeleteButtonWidth: CGFloat = 30.0

protocol ContentYouTubePlayerCellDelegate: NSObjectProtocol {
  func contentYouTubePlayerCellDidRemoveVideo(_ cell: ContentYouTubePlayerCell)
}

class ContentYouTubePlayerCell: UITableViewCell {

  private let youtubePlayerView = CrowsYouTubePlayerView()

  private let deleteButton = UIButton()

  var youtubeVideoID: String? {
    didSet {
      guard let youtubeVideoID = youtubeVideoID else { return }
      youtubePlayerView.loadVideoID(youtubeVideoID)
    }
  }

  weak var delegate: ContentYouTubePlayerCellDelegate?

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
    contentView.addSubview(youtubePlayerView)

    deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
    deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
    contentView.addSubview(deleteButton)
  }

  private func configureConstraints() {
    youtubePlayerView.translatesAutoresizingMaskIntoConstraints = false
    deleteButton.translatesAutoresizingMaskIntoConstraints = false

    let marginsGuide = contentView.layoutMarginsGuide
    let constraints = [
      youtubePlayerView.topAnchor.constraint(equalTo: marginsGuide.topAnchor),
      youtubePlayerView.leadingAnchor.constraint(equalTo: marginsGuide.leadingAnchor),
      youtubePlayerView.trailingAnchor.constraint(equalTo: marginsGuide.trailingAnchor),
      youtubePlayerView.bottomAnchor.constraint(equalTo: marginsGuide.bottomAnchor),
      youtubePlayerView.heightAnchor.constraint(equalTo: youtubePlayerView.widthAnchor, multiplier: 9.0/16),

      deleteButton.topAnchor.constraint(equalTo: youtubePlayerView.topAnchor, constant: DeleteButtonPadding),
      deleteButton.trailingAnchor.constraint(equalTo: youtubePlayerView.trailingAnchor, constant: -DeleteButtonPadding),
      deleteButton.widthAnchor.constraint(equalToConstant: DeleteButtonWidth),
      deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor)
    ]

    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - Actions
  @objc private func didTapDeleteButton() {
    youtubePlayerView.clear()
    delegate?.contentYouTubePlayerCellDidRemoveVideo(self)
  }

}
