//
//  LoadingView.swift
//  Crows
//
//  Created by Yingwei Fan on 4/29/21.
//

import UIKit

class LoadingView: UIView {

  private let spinner = UIActivityIndicatorView()

  override init(frame: CGRect) {
    super.init(frame: frame)

    configureSubviews()
    configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private

  private func configureSubviews() {
    spinner.style = .medium
    addSubview(spinner)
    spinner.startAnimating()
  }

  private func configureConstraints() {
    spinner.translatesAutoresizingMaskIntoConstraints =  false

    let constraints = [
      spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
      spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }

}
