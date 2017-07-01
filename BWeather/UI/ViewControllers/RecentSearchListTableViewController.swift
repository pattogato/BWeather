//
//  RecentSearchListTableViewController.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 06. 02..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import UIKit
import SnapKit

protocol RecentSearchListDelegate: class {
  func itemTouched(text city: String)
}

final class RecentSearchListTableViewController: UITableViewController {
  
  fileprivate struct Constants {
    static let cityCellId = "RecentSearchTableViewCell"
  }
  
  weak var delegate: RecentSearchListDelegate?
  var dataProvider: RecentSearchListDataProviderProtocol!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.rightBarButtonItem?.title = "recent.edit".localized
  }
  
  fileprivate func showNoItemsLabel(_ show: Bool) {
    if show {
      let label = UILabel()
      label.text = "recent.noitems".localized
      label.textColor = UIColor.lightGray
      label.textAlignment = .center
      label.numberOfLines = 0
      tableView.backgroundView = label
      label.snp.makeConstraints({ (make) in
        make.centerX.equalTo(tableView.snp.centerX)
        make.centerY.equalTo(tableView.snp.centerY)
          .offset(-(navigationController?.navigationBar.frame.height ?? 0))
        make.leading.equalTo(tableView.snp.leading)
          .offset(16)
        make.trailing.equalTo(tableView.snp.trailing)
          .offset(16)
      })
    } else {
      tableView.backgroundView = nil
    }
  }
  
  // MARK: - IBActions
  
  @IBAction func editButtonDidTouch(_ sender: UIBarButtonItem) {
    tableView.isEditing = !tableView.isEditing
    self.navigationItem.rightBarButtonItem?.title =
      tableView.isEditing ? "recent.done".localized : "recent.edit".localized
  }
  
}

// MARK: - Tableview delegate methods

extension RecentSearchListTableViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numberOfCells = dataProvider.numberOfItems()
    showNoItemsLabel(numberOfCells == 0)
    return numberOfCells
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cityCellId, for: indexPath)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let data = dataProvider.item(at: indexPath)
    cell.textLabel?.text = data.name
    cell.detailTextLabel?.text = data.extraInfo
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      tableView.beginUpdates()
      dataProvider.deleteItem(at: indexPath)
      tableView.deleteRows(at: [indexPath], with: .automatic)
      tableView.endUpdates()
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    self.navigationController?.popViewController(animated: true)
    self.delegate?.itemTouched(text: self.dataProvider.item(at: indexPath).name)
  }
  
}
