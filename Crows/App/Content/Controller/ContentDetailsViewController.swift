//
//  ContentDetailsViewController.swift
//  Crows
//
//  Created by Yingwei Fan on 4/4/21.
//

import UIKit

// Constants
private let CommentCellReuseIdentifier = "CommentCell"

class ContentDetailsViewController: BaseLoadViewController, UITableViewDataSource, UITableViewDelegate, ToolBarDelegate {

  var contentID: String

  private var contentDetailsObject: ContentDetailsObject?

  private var commentObjects: [ContentCommentObject]?

  lazy private var tableView = UITableView()

  lazy private var contentDetailsCell: ContentDetailsCell = {
    let cell = ContentDetailsCell(style: .default, reuseIdentifier: nil)
    return cell
  }()

  private let toolBar = ContentDetailsToolBar()

  private var commentToolBarViewBottomConstraint: NSLayoutConstraint!

  init(contentID: String) {
    self.contentID = contentID
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    fetchData()
  }

  override func didLoadDataSuccessfully() {
    super.didLoadDataSuccessfully()

    configureSubviews()
    configureConstraints()
  }

  // MARK: - Private

  private func configureSubviews() {
    tableView.backgroundColor = .clear
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCellReuseIdentifier)
    view.addSubview(tableView)

    // Remove redundant separator
    tableView.tableFooterView = UIView()

    toolBar.delegate = self
    view.addSubview(toolBar)
  }

  private func configureConstraints() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    toolBar.translatesAutoresizingMaskIntoConstraints = false

    commentToolBarViewBottomConstraint = toolBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    let safeAreaLayoutGuide = view.safeAreaLayoutGuide
    let constraints = [
      tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: toolBar.topAnchor),

      toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      commentToolBarViewBottomConstraint!
    ]
    NSLayoutConstraint.activate(constraints)
  }

  private func fetchData() {
    CrowsServices.shared.fetchContentDetails(contentID: contentID) { contentDetailsObject, commentObjects, error in
      guard let contentDetailsObject = contentDetailsObject else {
        if let error = error {
          debugPrint(error.localizedDescription)
          self.didFinishLoadingData(with: error)
        }
        return
      }
      self.contentDetailsObject = contentDetailsObject
      self.commentObjects = commentObjects
      self.toolBar.likeCount = contentDetailsObject.likeCount
      self.toolBar.commentCount = contentDetailsObject.commentCount
      self.didLoadDataSuccessfully()
    }
  }

  // MARK: - UITableViewDataSource

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return commentObjects?.count ?? 0
    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    switch indexPath.section {
    case 0:
      contentDetailsCell.object = contentDetailsObject
      cell = contentDetailsCell
    default:
      guard let commentCell = tableView.dequeueReusableCell(withIdentifier: CommentCellReuseIdentifier,
                                                            for: indexPath) as? CommentCell else {
        return CommentCell()
      }
      commentCell.object = commentObjects?[indexPath.row]
      cell = commentCell
    }
    cell.selectionStyle = .none

    return cell
  }

  // MARK: - ToolBarDelegate

  func toolBar(_ toolBar: UIView, didTapLikeButton button: UIButton) {

  }

  func toolBar(_ toolBar: UIView, didTapCommentButton button: UIButton) {
    let discussionID = contentDetailsObject?.idString ?? ""
    let createCommentViewController = CreateCommentViewController(discussionID: discussionID)
    navigationController?.pushViewController(createCommentViewController, animated: true)
  }

//  func toolBar(_ toolBar: UIView, didTapForwardButton button: UIButton) {
//
//  }
}

// MARK: - ToolBar -

private let StackHeight: CGFloat = 44.0

private protocol ToolBarDelegate: NSObjectProtocol {
  func toolBar(_ toolBar: UIView, didTapLikeButton button: UIButton)
  func toolBar(_ toolBar: UIView, didTapCommentButton button: UIButton)
//  func toolBar(_ toolBar: UIView, didTapForwardButton button: UIButton)
}

private class ContentDetailsToolBar: UIView {

  private let stackView = UIStackView()

  private let likeButton = AnimationButton()

  private let commentButton = AnimationButton()

  var likeCount = 0 {
    didSet {
      if likeCount > 0 {
        likeButton.setTitle("\(likeCount)", for: .normal)
        likeButton.setTitle("\(likeCount)", for: .selected)
      } else {
        likeButton.setTitle(nil, for: .normal)
        likeButton.setTitle(nil, for: .selected)
      }
    }
  }

  var commentCount = 0 {
    didSet {
      if commentCount > 0 {
        commentButton.setTitle("\(commentCount)", for: .normal)
      } else {
        commentButton.setTitle(nil, for: .normal)
      }
    }
  }

//  private let forwardButton = AnimationButton()

  weak var delegate: ToolBarDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = CrowsColor.background1
    layer.shadowColor = CrowsColor.shadow.cgColor
    layer.shadowOpacity = 0.7
    layer.shadowOffset = CGSize(width: 0, height: 1)
    layer.shadowRadius = 3.0
    configureSubviews()
    configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
      layer.shadowColor = CrowsColor.shadow.cgColor
    }
  }

  // MARK: - Private

  private func configureSubviews() {
    likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
    likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .selected)
    likeButton.titleLabel?.font = CrowsFont.text
    likeButton.setTitleColor(CrowsColor.grey800, for: .normal)
    likeButton.addTarget(self, action: #selector(didTapLikeButton(_:)), for: .touchUpInside)
    stackView.addArrangedSubview(likeButton)

    commentButton.setImage(UIImage(systemName: "text.bubble"), for: .normal)
    commentButton.titleLabel?.font = CrowsFont.text
    commentButton.setTitleColor(CrowsColor.grey800, for: .normal)
    commentButton.addTarget(self, action: #selector(didTapCommentButton(_:)), for: .touchUpInside)
    stackView.addArrangedSubview(commentButton)

//    forwardButton.setImage(UIImage(systemName: "arrowshape.turn.up.right.circle"), for: .normal)
//    forwardButton.addTarget(self, action: #selector(didTapForwardButton(_:)), for: .touchUpInside)
//    stackView.addArrangedSubview(forwardButton)

    stackView.alignment = .center
    stackView.distribution = .fillEqually
    addSubview(stackView)
  }

  private func configureConstraints() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    likeButton.translatesAutoresizingMaskIntoConstraints = false
    commentButton.translatesAutoresizingMaskIntoConstraints = false

    let safeAreaLayoutGuide = self.safeAreaLayoutGuide
    let constraints = [
      stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      stackView.heightAnchor.constraint(equalToConstant: StackHeight),

      likeButton.heightAnchor.constraint(equalTo: stackView.heightAnchor),

      commentButton.heightAnchor.constraint(equalTo: stackView.heightAnchor),

//      forwardButton.heightAnchor.constraint(equalTo: stackView.heightAnchor)
    ]

    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - Actions

  @objc private func didTapLikeButton(_ button: UIButton) {
    if button.isSelected {
      button.isSelected = false
      likeCount -= 1
    } else {
      button.isSelected = true
      likeCount += 1
    }
    delegate?.toolBar(self, didTapLikeButton: button)
  }

  @objc private func didTapCommentButton(_ button: UIButton) {
    delegate?.toolBar(self, didTapCommentButton: button)
  }

//  @objc private func didTapForwardButton(_ button: UIButton) {
//    delegate?.toolBar(self, didTapForwardButton: button)
//  }
}
