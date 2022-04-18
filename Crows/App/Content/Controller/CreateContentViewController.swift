//
//  CreateContentViewController.swift
//  Crows
//
//  Created by Yingwei Fan on 3/30/21.
//

import UIKit
import MBProgressHUD

// Constants
private let TableViewBottomContentInset: CGFloat = 360.0
private let ScrollToCursorMoreOffset: CGFloat = 10.0

class CreateContentViewController: UIViewController,
                                   UITableViewDataSource,
                                   UITableViewDelegate,
                                   UIImagePickerControllerDelegate,
                                   UINavigationControllerDelegate,
                                   UITextFieldDelegate,
                                   ContentPhotosCellDelegate,
                                   TextViewTableViewCellDelegate,
                                   CreateContentToolBarDelegate,
                                   AddYouTubeLinkViewControllerDelegate,
                                   ContentYouTubePlayerCellDelegate {

  private enum ContentCellType: Int, CaseIterable {
    case title = 0
    case media = 1
    case body = 2
    case circleSelect = 3
  }

  private let tableView = UITableView()
  // Static cells.
  lazy private var titleCell: TextFieldTableViewCell = {
    let cell = TextFieldTableViewCell(style: .default, reuseIdentifier: nil)
    cell.placeholder = NSLocalizedString("CreateContent.TitlePlaceholder", comment: "")
    cell.textField.delegate = self
    return cell
  }()
  lazy private var forwardCell = CreateContentForwardCell(style: .default, reuseIdentifier: nil)
  lazy private var photosCell: CreateContentPhotosCell = {
    let cell = CreateContentPhotosCell(style: .default, reuseIdentifier: nil)
    cell.delegate = self
    return cell
  }()
  lazy private var youtubePlayerCell: ContentYouTubePlayerCell = {
    let cell = ContentYouTubePlayerCell(style: .default, reuseIdentifier: nil)
    cell.delegate = self
    return cell
  }()
  lazy private var textCell: TextViewTableViewCell = {
    let cell = TextViewTableViewCell(style: .default, reuseIdentifier: nil)
    cell.placeholder = NSLocalizedString("CreateContent.TextPlaceholder", comment: "")
    cell.delegate = self
    return cell
  }()
  lazy private var circleSelectCell: UITableViewCell = {
    let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
    cell.backgroundColor = .clear
    cell.textLabel?.text = NSLocalizedString("CreateContent.CircleSelection", comment: "")
    cell.accessoryType = .disclosureIndicator
    return cell
  }()

  private var uploadItem: UIBarButtonItem!

  private let toolBar = CreateContentToolBar()

  private var toolBarBottomConstraint: NSLayoutConstraint!

  var forwardContentObject: BaseContentObject?

  private var photos = [UIImage]()

  private var youtubeVideoLink: String? {
    didSet {
      guard youtubeVideoLink != nil else { return }
      tableView.reloadData()
    }
  }

  private var shouldHideMediaCell: Bool {
    return forwardContentObject == nil && photos.isEmpty && youtubeVideoLink == nil
  }

  convenience init(forwardContentObject: BaseContentObject?) {
    self.init()

    self.forwardContentObject = forwardContentObject
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = CrowsColor.white
    configureSubviews()
    configureConstraints()

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillChangeFrame(_:)),
                                           name: UIResponder.keyboardWillChangeFrameNotification,
                                           object: nil)
  }

  // MARK: - Private

  private func configureSubviews() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(didTapCloseButton(_:)))
    uploadItem = UIBarButtonItem(title: NSLocalizedString("CreateContent.Upload", comment: ""),
                                 style: .done,
                                 target: self,
                                 action: #selector(didTapUploadButton(_:)))
//    uploadItem.isEnabled = false
    navigationItem.rightBarButtonItem = uploadItem
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: TableViewBottomContentInset, right: 0)
    tableView.dataSource = self
    tableView.delegate = self
    view.addSubview(tableView)

    toolBar.delegate = self
    view.addSubview(toolBar)
  }

  private func configureConstraints() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    toolBar.translatesAutoresizingMaskIntoConstraints = false

    let safeAreaLayoutGuide = view.safeAreaLayoutGuide
    toolBarBottomConstraint = toolBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    let constraints = [
      tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

      toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      toolBarBottomConstraint!
    ]
    NSLayoutConstraint.activate(constraints)
  }

  private func scrollToTextViewCursor(_ animated: Bool) {
    guard let bodyCell = tableView.cellForRow(at: IndexPath(item: 2, section: 0)) as? TextViewTableViewCell,
          bodyCell.textView.isFirstResponder else {
      return
    }
    guard let endPosition = bodyCell.textView.selectedTextRange?.end else { return }
    let cursorRect = bodyCell.textView.caretRect(for: endPosition)
    let cursorRectInView = view.convert(cursorRect, from: bodyCell.textView)
    let yOffset = cursorRectInView.maxY - toolBar.frame.minY
    guard yOffset > 0 else { return }
    var contentOffsest = tableView.contentOffset
    contentOffsest.y += yOffset + ScrollToCursorMoreOffset
    tableView.setContentOffset(contentOffsest, animated: animated)
  }

  private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
    guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }

    let imagePickerController = UIImagePickerController()
    imagePickerController.mediaTypes = ["public.image"]
    imagePickerController.sourceType = sourceType
    imagePickerController.delegate = self
    present(imagePickerController, animated: true, completion: nil)
  }

  private func chooseImageSource() {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let cameraAction = UIAlertAction(title: NSLocalizedString("TakePhoto", comment: ""), style: .default) { action in
      self.openImagePicker(sourceType: .camera)
    }
    alertController.addAction(cameraAction)
    let albumAction = UIAlertAction(title: NSLocalizedString("ChoosePhoto", comment: ""), style: .default) { action in
      self.openImagePicker(sourceType: .photoLibrary)
    }
    alertController.addAction(albumAction)
    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    present(alertController, animated: true, completion: nil)
  }

  // MARK: - Actions

  @objc private func didTapCloseButton(_ button: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

  @objc private func didTapUploadButton(_ button: UIBarButtonItem) {
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    hud.label.text = NSLocalizedString("CreateContent.Uploading", comment: "")
    let title = titleCell.textField.text ?? ""
    var text = textCell.textView.text ?? ""
    if textCell.isShowingPlaceholder {
      text = ""
    }
    CrowsServices.shared.uploadContent(title: title, text: text, images: photos, videoLink: youtubeVideoLink) { success, error in
      guard success else {
        hud.mode = .text
        hud.label.numberOfLines = 0
        hud.label.text = error?.localizedDescription
        hud.hide(animated: true, afterDelay: 1.5)
        return
      }
      hud.hide(animated: true)
      self.dismiss(animated: true, completion: nil)
    }
  }

  @objc private func keyboardWillChangeFrame(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue,
          let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue,
          let curve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as AnyObject).integerValue else {
      return
    }

    toolBarBottomConstraint.constant = endFrame.origin.y < view.frame.maxY ? -endFrame.height : 0
    let options = UIView.AnimationOptions(rawValue: UInt(curve))
    UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
      self.view.layoutIfNeeded()
    }, completion: nil)

  }

  // MARK: - UITableViewDataSource

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ContentCellType.allCases.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    switch indexPath.row {
    case ContentCellType.title.rawValue:
      cell = titleCell
      cell.selectionStyle = .none
    case ContentCellType.media.rawValue:
      if let forwardContentObject = forwardContentObject {
        forwardCell.object = forwardContentObject
        cell = forwardCell
        toolBar.contentType = .forwardContent
      } else if photos.count > 0 {
        photosCell.photos = photos
        photosCell.reloadAndRelayoutCollectionView()
        cell = photosCell
        toolBar.contentType = .image
      } else if let youtubeVideoLink = youtubeVideoLink {
        youtubePlayerCell.youtubeVideoID = youtubeVideoLink.youtubeID
        cell = youtubePlayerCell
        toolBar.contentType = .externalVideo
      } else {
        cell = UITableViewCell()
        cell.isHidden = true
        toolBar.contentType = .none
      }
      cell.selectionStyle = .none
    case ContentCellType.body.rawValue:
      cell = textCell
      cell.selectionStyle = .none
    case ContentCellType.circleSelect.rawValue:
      cell = circleSelectCell
    default:
      cell = UITableViewCell()
      debugPrint("Error: indexPath is wrong")
    }

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == ContentCellType.media.rawValue, shouldHideMediaCell {
      return 0
    }
    return UITableView.automaticDimension
  }

  // MARK: - UITableViewDelegate

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.row == ContentCellType.circleSelect.rawValue else { return }

    let circlesListViewController = CirclesListViewController()
    circlesListViewController.isSelecting = true
    navigationController?.pushViewController(circlesListViewController, animated: true)

    tableView.deselectRow(at: indexPath, animated: true)
  }

  // MARK: - UIImagePickerControllerDelegate

  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true, completion: nil)

    guard let image = info[.originalImage] as? UIImage else {
      return
    }
    photos.append(image)
    tableView.reloadData()
  }

  // MARK: - UITextFieldDelegate

  func textFieldDidBeginEditing(_ textField: UITextField) {
    // Prevent table view to scroll away.
    tableView.setContentOffset(.zero, animated: true)
  }

  // MARK: - TextViewTableViewCellDelegate

  func textViewTableViewCell(_ cell: TextViewTableViewCell, didBeginEditing textView: UITextView) {
    // Prevent table view to scroll away.
    let contentOffset = tableView.contentOffset
    tableView.setContentOffset(contentOffset, animated: false)
  }

  func textViewTableViewCell(_ cell: TextViewTableViewCell, didChange textView: UITextView) {
    UIView.setAnimationsEnabled(false)
    tableView.beginUpdates()
    tableView.endUpdates()
    // (IMPORTANT) Relayout to allow the setContentOffset to take effect.
    tableView.layoutIfNeeded()
    UIView.setAnimationsEnabled(true)

    scrollToTextViewCursor(true)
  }

  // MARK: - ContentPhotosCellDelegate

  func createContentPhotosCellDidTapAddPhoto(_ cell: CreateContentPhotosCell) {
    chooseImageSource()
  }

  func createContentPhotosCell(_ cell: CreateContentPhotosCell, didRemovePhotoAt index: Int) {
    photos.remove(at: index)
    tableView.reloadData()
  }

  // MARK: - CreateContentToolBarDelegate

  func createContentToolBar(_ toolBar: CreateContentToolBar, didTapAddImage button: UIButton) {
    chooseImageSource()
  }

  func createContentToolBar(_ toolBar: CreateContentToolBar, didTapAddExternalVideo button: UIButton) {
    let addYouTubeLinkViewController = AddYouTubeLinkViewController()
    addYouTubeLinkViewController.delegate = self
    present(addYouTubeLinkViewController, animated: true, completion: nil)
  }

  // MARK: - AddYouTubeLinkViewControllerDelegate

  func addYouTubeLinkViewController(_ viewController: AddYouTubeLinkViewController, didAdd youtubeVideoLink: String) {
    self.youtubeVideoLink = youtubeVideoLink
  }

  // MARK: - ContentYouTubePlayerCellDelegate

  func contentYouTubePlayerCellDidRemoveVideo(_ cell: ContentYouTubePlayerCell) {
    youtubeVideoLink = nil
    tableView.reloadData()
  }

}
