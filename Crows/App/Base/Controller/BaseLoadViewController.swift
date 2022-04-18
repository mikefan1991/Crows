//
//  BaseLoadViewController.swift
//  Crows
//
//  Created by Yingwei Fan on 5/5/21.
//

import UIKit
import Alamofire

class BaseLoadViewController: UIViewController, ErrorViewDelegate {

  private let loadingView = LoadingView()

  lazy private var errorView = ErrorView()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = CrowsColor.background
    displayLoadingView()
  }

  // MARK: - Private

  private func displayLoadingView() {
    view.addSubview(loadingView)
    loadingView.translatesAutoresizingMaskIntoConstraints = false
    let constraints = [
      loadingView.topAnchor.constraint(equalTo: view.topAnchor),
      loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  private func displayErrorView(with error: AFError) {
    errorView.delegate = self
    view.addSubview(errorView)
    errorView.translatesAutoresizingMaskIntoConstraints = false
    let constraints = [
      errorView.topAnchor.constraint(equalTo: view.topAnchor),
      errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - Public

  func didLoadDataSuccessfully() {
    loadingView.removeFromSuperview()
  }

  /** Sub classes should override this function like viewDidLoad. */
  func didFinishLoadingData(with error: AFError) {
    loadingView.removeFromSuperview()
    displayErrorView(with: error)
  }

  // MARK: - ErrorViewDelegate

  func errorView(_ errorView: ErrorView, didTapRetry button: UIButton) {
    errorView.removeFromSuperview()
    displayLoadingView()
  }

}
