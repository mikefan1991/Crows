//
//  CreateCommentViewController.swift
//  Crows
//
//  Created by Yingwei Fan on 6/5/21.
//

import UIKit
import MBProgressHUD

class CreateCommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TextViewTableViewCellDelegate {

  private let tableView = UITableView()

  private let textViewCell = TextViewTableViewCell()

  let discussionID: String

  init(discussionID: String) {
    self.discussionID = discussionID
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    title = NSLocalizedString("CreateContent.CreateComment", comment: "")
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("CreateContent.Upload", comment: ""),
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(didTapUpload(_:)))
    configureSubviews()
    configureConstraints()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    textViewCell.textView.becomeFirstResponder()
  }

  // MARK: - Private

  private func configureSubviews() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.allowsSelection = false
    tableView.tableFooterView = UIView()
    view.addSubview(tableView)

    textViewCell.delegate = self
  }

  private func configureConstraints() {
    tableView.translatesAutoresizingMaskIntoConstraints = false

    let constraints = [
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - UITableViewDataSource

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return textViewCell
  }

  // MARK: - TextViewTableViewCellDelegate

  func textViewTableViewCell(_ cell: TextViewTableViewCell, didBeginEditing textView: UITextView) {
    // No-op
  }

  func textViewTableViewCell(_ cell: TextViewTableViewCell, didChange textView: UITextView) {
    UIView.setAnimationsEnabled(false)
    tableView.beginUpdates()
    tableView.endUpdates()
    UIView.setAnimationsEnabled(true)
  }

  // MARK: - Actions

  @objc private func didTapUpload(_ button: UIBarButtonItem) {
    guard let content = textViewCell.textView.text, !content.isEmpty else {
      textViewCell.textView.shake()
      return
    }
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    hud.label.numberOfLines = 0
    CrowsServices.shared.uploadComment(discussionID: discussionID, content: content) { success, error in
      guard success else {
        hud.mode = .text
        hud.label.text = error?.localizedDescription
        hud.hide(animated: true, afterDelay: 1.5)
        return
      }
      hud.hide(animated: true)
      self.navigationController?.popViewController(animated: true)
    }
  }

}
