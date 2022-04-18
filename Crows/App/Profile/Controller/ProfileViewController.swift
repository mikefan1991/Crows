//
//  ProfileViewController.swift
//  Crows
//
//  Created by Yingwei Fan on 3/29/21.
//

import UIKit
import MBProgressHUD

private let ProfileHeaderHeight: CGFloat = 100.0

class ProfileViewController: UIViewController,
                             UITableViewDataSource,
                             UITableViewDelegate,
                             ProfileHeaderViewDelegate,
                             UIImagePickerControllerDelegate,
                             UINavigationControllerDelegate {

  private let tableView = UITableView(frame: .zero, style: .grouped)

  private let profileHeaderView = ProfileHeaderView()

  private var authorObject: AuthorObject! {
    didSet {
      profileHeaderView.name = authorObject.username
      profileHeaderView.avatarURL = authorObject.avatarURL
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = CrowsColor.background
    navigationItem.title = NSLocalizedString("Me", comment: "")
    if let authorData = CrowsUserDefaults.standard.data(forKey: CrowsUserDefaults.loginUserKey) {
      let decoder = JSONDecoder()
      let authorObject = try? decoder.decode(AuthorObject.self, from: authorData)
      self.authorObject = authorObject
    }
    configureSubviews()
    configureConstraints()
  }

  // MARK: - Private

  private func configureSubviews() {
    tableView.backgroundColor = .clear
    tableView.dataSource = self
    tableView.delegate = self
    view.addSubview(tableView)

    profileHeaderView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: ProfileHeaderHeight)
    profileHeaderView.delegate = self
    tableView.tableHeaderView = profileHeaderView
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

  private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
    guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }

    let imagePickerController = UIImagePickerController()
    imagePickerController.mediaTypes = ["public.image"]
    imagePickerController.sourceType = sourceType
    imagePickerController.delegate = self
    present(imagePickerController, animated: true, completion: nil)
  }

  // MARK: - UITableViewDataSource

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
    cell.backgroundColor = CrowsColor.background1
    cell.textLabel?.text = NSLocalizedString("Profile.ChangePassword", comment: "")
    return cell
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard section != 0 else { return nil }
    let sectionHeaderView = UIView()
    sectionHeaderView.backgroundColor = CrowsColor.grey300
    return sectionHeaderView
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return nil
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return CGFloat.leastNonzeroMagnitude
  }

  // MARK: - UITableViewDelegate

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    if indexPath.section == 0, indexPath.row == 0 {
      let title = NSLocalizedString("Profile.ChangePassword", comment: "")
      let message = NSLocalizedString("Profile.ChangePasswordMessage", comment: "")
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let sendAction = UIAlertAction(title: NSLocalizedString("Profile.SendPasswordResetEmail", comment: ""), style: .default) { action in

      }
      alertController.addAction(sendAction)
      let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
      alertController.addAction(cancelAction)
      present(alertController, animated: true, completion: nil)
    }
  }

  // MARK: - ProfileHeaderViewDelegate

  func profileHeaderView(_ profileHeaderView: ProfileHeaderView, didTap: UIImageView) {
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

  // MARK: - UIImagePickerControllerDelegate

  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    picker.dismiss(animated: true, completion: nil)

    guard let image = info[.originalImage] as? UIImage else {
      hud.hide(animated: true)
      return
    }

    CrowsServices.shared.updateAvatar(image: image) { imageURL, error in
      guard let imageURL = imageURL else {
        hud.mode = .text
        hud.label.text = error?.localizedDescription ?? "Update avatar failed";
        hud.hide(animated: true, afterDelay: 1.5)
        return
      }
      hud.hide(animated: true)
      self.profileHeaderView.setImage(image, with: imageURL)
    }
  }

}
