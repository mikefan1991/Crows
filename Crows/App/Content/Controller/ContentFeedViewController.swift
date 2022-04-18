//
//  HomeFeedViewController.swift
//  Crows
//
//  Created by Yingwei Fan on 4/3/21.
//

import UIKit
import Alamofire

class ContentFeedViewController: BaseLoadViewController, UITableViewDataSource, UITableViewDelegate {

  var objects = [BaseContentObject]()

  final lazy var tableView = UITableView()

  private lazy var loadingCell: UITableViewCell = {
    let cell = UITableViewCell()
    let loadingView = LoadingView()
    cell.contentView.addSubview(loadingView)
    loadingView.translatesAutoresizingMaskIntoConstraints = false
    let constraints = [
      loadingView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
      loadingView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
      loadingView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
      loadingView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
    return cell
  }()

  private var isLoading = false

  private var isContentEnded = false

  override func viewDidLoad() {
    super.viewDidLoad()

    fetchData(isRefresh: false)
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
    tableView.register(BaseContentCell.self, forCellReuseIdentifier: BaseContentCell.reuseIdentifier)

    let dataRefreshControl = UIRefreshControl()
    dataRefreshControl.addTarget(self, action: #selector(refreshContent(_:)), for: .valueChanged)
    tableView.refreshControl = dataRefreshControl
    view.addSubview(tableView)

    tableView.translatesAutoresizingMaskIntoConstraints = false
    let constraints = [
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }

  private func fetchData(isRefresh: Bool = true) {
    guard !isLoading else { return }
    isLoading = true
    CrowsServices.shared.fetchContentFeed(startIndex: 0) { objects, error in
      self.tableView.refreshControl?.endRefreshing()
      self.isLoading = false
      guard let objects = objects else {
        if let error = error {
          if isRefresh {
            debugPrint(error.localizedDescription)
          } else {
            self.didFinishLoadingData(with: error)
          }
        }
        return
      }

      self.objects = objects
      if isRefresh {
        self.tableView.reloadData()
      } else {
        self.didLoadDataSuccessfully()
      }
    }
  }

  private func fetchMoreData() {
    guard !isLoading else { return }
    isLoading = true
    CrowsServices.shared.fetchContentFeed(startIndex: objects.count) { objects, error in
      self.isLoading = false
      guard let objects = objects else {
        if let error = error  {
          debugPrint(error.localizedDescription)
        }
        return
      }
      if objects.isEmpty {
        self.isContentEnded = true
        self.tableView.deleteSections([1], with: .fade)
        return
      }
      self.objects.append(contentsOf: objects)
      self.tableView.reloadData()
    }
  }

  // MARK: - UITableViewDataSource

  func numberOfSections(in tableView: UITableView) -> Int {
    if !isContentEnded, objects.count > 19 {
      return 2
    }
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 1 {
      return 1
    }
    return objects.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 1 {
      return loadingCell
    }
    guard let cell = tableView.dequeueReusableCell(withIdentifier: BaseContentCell.reuseIdentifier, for: indexPath) as? BaseContentCell else {
      return UITableViewCell()
    }

    cell.object = objects[indexPath.row]

    return cell
  }

  // MARK: - UITableViewDelegate

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let contentID = objects[indexPath.row].idString
    let contentDetailsViewController = ContentDetailsViewController(contentID: contentID)
    navigationController?.pushViewController(contentDetailsViewController, animated: true)

    tableView.deselectRow(at: indexPath, animated: true)
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard indexPath.section == 1 else {
      return
    }

    fetchMoreData()
  }

  // MARK: - Actions

  @objc private func refreshContent(_ refreshControl: UIRefreshControl) {
    fetchData()
  }

}
