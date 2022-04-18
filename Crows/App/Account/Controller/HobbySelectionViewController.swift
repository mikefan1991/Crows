//
//  HobbySelectionViewController.swift
//  Crows
//
//  Created by Yingwei Fan on 4/7/21.
//

import UIKit

private let HobbyCellReuseIdentifier = "HobbyCell"

class HobbySelectionViewController: UIViewController,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout {

  lazy private var flowLayout: UICollectionViewFlowLayout = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumLineSpacing = VerticalPadding.standard.rawValue
    flowLayout.minimumInteritemSpacing = HorizontalPadding.standard.rawValue
    flowLayout.scrollDirection = .vertical
    return flowLayout
  }()

  lazy private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

  private let hobbyNameKeys = [
    "Hobby.Alcohol",
    "Hobby.Photography",
    "Hobby.Sports",
    "Hobby.Digital",
    "Hobby.Cars",
    "Hobby.UrbanLegend",
    "Hobby.Finance",
    "Hobby.Fashion"
  ]

  private var selectedIndices = Set<Int>()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = CrowsColor.white
    navigationItem.title = NSLocalizedString("HobbySelectionTitle", comment: "")
    navigationItem.setHidesBackButton(true, animated: false)
    let rightBarButtonItem =
        UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .done, target: self, action: #selector(didTapDoneButton(_:)))
    navigationItem.rightBarButtonItem = rightBarButtonItem
    configureSubviews()
    configureConstraints()
  }

  // MARK: - Private

  private func configureSubviews() {
    collectionView.backgroundColor = .clear
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(HobbyCell.self, forCellWithReuseIdentifier: HobbyCellReuseIdentifier)
    view.addSubview(collectionView)
  }

  private func configureConstraints() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false

    let safeAreaLayoutGuide = view.safeAreaLayoutGuide
    let constraints = [
      collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: VerticalPadding.standard.rawValue),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: HorizontalPadding.standard.rawValue),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -HorizontalPadding.standard.rawValue),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ]

    NSLayoutConstraint.activate(constraints)
  }

  // MARK: - UICollectionViewDataSource

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hobbyNameKeys.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HobbyCellReuseIdentifier, for: indexPath) as? HobbyCell else {
      return HobbyCell()
    }
    cell.hobbyName = NSLocalizedString(hobbyNameKeys[indexPath.item], comment: "")
    if let imagePath = Bundle.main.path(forResource: "HobbyBackground", ofType: "png") {
      cell.hobbyImage = UIImage(contentsOfFile: imagePath)
    }

    return cell
  }

  // MARK: - UICollectionViewDelegate

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? HobbyCell else { return }

    cell.isHobbySelected = !cell.isHobbySelected
    if cell.isHobbySelected {
      selectedIndices.insert(indexPath.item)
    } else {
      selectedIndices.remove(indexPath.item)
    }
  }

  // MARK: - UICollectionViewDelegateFlowLayout

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.bounds.width - flowLayout.minimumInteritemSpacing) / 2
    let height = width / 3 * 2
    return CGSize(width: width, height: height)
  }

  // MARK: - Actions

  @objc private func didTapDoneButton(_ button: UIBarButtonItem) {
    guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
    UIView.transition(with: keyWindow, duration: 1, options: .transitionCurlUp, animations: {
      UIView.setAnimationsEnabled(false)
      keyWindow.rootViewController = RootTabBarViewController()
      UIView.setAnimationsEnabled(true)
    }, completion: nil)
  }

}
