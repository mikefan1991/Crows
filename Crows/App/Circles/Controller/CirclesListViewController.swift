//
//  CirclesListViewController.swift
//  Crows
//
//  Created by Yingwei Fan on 4/18/21.
//

import UIKit

class CirclesListViewController: BaseLoadViewController, UITableViewDataSource, UITableViewDelegate {

  lazy private var tableView = UITableView()

  // Whether the button of the cell should be select instead of join.
  var isSelecting = false

  override func viewDidLoad() {
    super.viewDidLoad()

    fetchData()
  }

  override func didLoadDataSuccessfully() {
    super.didLoadDataSuccessfully()

    configureTableView()
  }

  // MARK: - Private

  private func configureTableView() {
    tableView.backgroundColor = .clear
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = UIView()
    tableView.register(CircleListCell.self, forCellReuseIdentifier: CircleListCell.reuseIdentifier)
    view.addSubview(tableView)

    tableView.translatesAutoresizingMaskIntoConstraints = false
    let constraints = [
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  private func fetchData() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.didLoadDataSuccessfully()
    }
  }

  // MARK: - UITableViewDataSource

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CircleListCell.reuseIdentifier, for: indexPath) as? CircleListCell else {
      return CircleListCell(style: .default, reuseIdentifier: CircleListCell.reuseIdentifier)
    }
    cell.shouldShowSelect = isSelecting
    return cell
  }

  // MARK: - UITableViewDelegate

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    let circleDetailViewController = CircleDetailsBaseViewController()
    navigationController?.pushViewController(circleDetailViewController, animated: true)
  }

}
