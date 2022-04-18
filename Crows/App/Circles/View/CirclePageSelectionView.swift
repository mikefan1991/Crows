//
//  CirclePageSelectionView.swift
//  Crows
//
//  Created by Yingwei Fan on 4/14/21.
//

import UIKit

// Constants
private let HorizontalInset: CGFloat = 8.0
private let TitleButtonIntrinsicPadding: CGFloat = 8.0
private let BottomIndicatorWidth: CGFloat = 30.0
private let BottomIndicatorHeight: CGFloat = 4.0
private let BottomSeparatorHeight: CGFloat = 1.0

protocol CirclePageSelectionViewDelegate: NSObjectProtocol {
  func circlePageSelectionView(_ selectionView: CirclePageSelectionView, didSelect titleButton: UIButton)
}

class CirclePageSelectionView: UIView {

  private let pageTitles: [String]

  private let titleButtons: [UIButton]

  private let bottomIndicator = UIView()

//  lazy private var bottomSeparatorLayer: CALayer = {
//    let bottomSeparatorLayer = CALayer()
//    bottomSeparatorLayer.backgroundColor = UIColor.lightGray.cgColor
//    layer.addSublayer(bottomSeparatorLayer)
//    return bottomSeparatorLayer
//  }()

  var selectedIndex = 0 {
    didSet {
      guard selectedIndex != oldValue else { return }
      let preSelectedButton = titleButtons[oldValue]
      preSelectedButton.isSelected = false
      let selectedButton = titleButtons[selectedIndex]
      selectedButton.isSelected = true
    }
  }

  var bottomIndicatorProgress: CGFloat = 0 {
    didSet {
      guard let firstButton = titleButtons.first, let lastButton = titleButtons.last else { return }
      let distance = lastButton.center.x - firstButton.center.x
      bottomIndicatorCenterXConstraint.constant = distance * bottomIndicatorProgress
    }
  }

  private let selectedColor = UIColor.orange

  weak var delegate: CirclePageSelectionViewDelegate?

  private let roundedCornerLayer = CALayer()

  private var bottomIndicatorCenterXConstraint: NSLayoutConstraint!

  required init(frame: CGRect, pageTitles: [String]) {
    self.pageTitles = pageTitles
    var buttons = [UIButton]()
    for _ in pageTitles {
      buttons.append(UIButton())
    }
    titleButtons = buttons
    super.init(frame: frame)

    backgroundColor = CrowsColor.background
    configureSubviews()
    configureConstraints()
  }

  @available(*, unavailable)
  init() {
    fatalError("init() cannot be used")
  }

  @available(*, unavailable)
  override init(frame: CGRect) {
    fatalError("init(frame:) cannot be used")
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()

//    bottomSeparatorLayer.frame = CGRect(x: 0,
//                                        y: layer.bounds.height - BottomSeparatorHeight,
//                                        width: layer.bounds.width,
//                                        height: BottomSeparatorHeight)
  }

  // MARK: - Private

  private func configureSubviews() {
    var i = 0
    for title in pageTitles {
      let button = titleButtons[i]
      button.setTitle(title, for: .normal)
      button.titleLabel?.font = CrowsFont.text
      button.setTitleColor(CrowsColor.grey650, for: .normal)
      button.setTitleColor(selectedColor, for: .selected)
      button.isSelected = (i == selectedIndex)
      button.tag = i
      button.addTarget(self, action: #selector(didTapTitle(_:)), for: .touchDown)
      addSubview(button)
      i += 1
    }

    bottomIndicator.backgroundColor = selectedColor
    bottomIndicator.layer.cornerRadius = BottomIndicatorHeight / 2
    bottomIndicator.layer.masksToBounds = true
    addSubview(bottomIndicator)
  }

  private func configureConstraints() {
    bottomIndicator.translatesAutoresizingMaskIntoConstraints = false

    bottomIndicatorCenterXConstraint = bottomIndicator.centerXAnchor.constraint(equalTo: titleButtons[0].centerXAnchor)
    var constraints = [
      bottomIndicator.bottomAnchor.constraint(equalTo: bottomAnchor),
      bottomIndicator.widthAnchor.constraint(equalToConstant: BottomIndicatorWidth),
      bottomIndicator.heightAnchor.constraint(equalToConstant: BottomIndicatorHeight),
      bottomIndicatorCenterXConstraint!
    ]

    for i in 0..<titleButtons.count {
      let button = titleButtons[i]
      button.translatesAutoresizingMaskIntoConstraints = false
      let buttonIntrinsicSize = button.intrinsicContentSize
      constraints += [
        button.leadingAnchor.constraint(equalTo: i == 0 ? layoutMarginsGuide.leadingAnchor : titleButtons[i-1].trailingAnchor,
                                        constant: HorizontalInset),
        button.bottomAnchor.constraint(equalTo: bottomAnchor),
        button.heightAnchor.constraint(equalTo: heightAnchor),
        button.widthAnchor.constraint(equalToConstant: buttonIntrinsicSize.width + TitleButtonIntrinsicPadding)
      ]
    }

    NSLayoutConstraint.activate(constraints)
  }

  private func moveBottomIndicator() {

  }

  // MARK: - Actions

  @objc private func didTapTitle(_ button: UIButton) {
    guard button.tag != selectedIndex else { return }

    selectedIndex = button.tag
    delegate?.circlePageSelectionView(self, didSelect: button)

    guard let firstButton = titleButtons.first else { return }
    let distance = button.center.x - firstButton.center.x
    bottomIndicatorCenterXConstraint.constant = distance
    UIView.animate(withDuration: 0.25) {
      self.layoutIfNeeded()
    }
  }

}
