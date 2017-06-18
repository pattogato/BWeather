//
//  RecentSearchListDataProvider.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 06. 05..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import Foundation

final class RecentSearchListDataProvider: RecentSearchListDataProviderProtocol {
  
  private let recentSearchStorage: RecentSearchStorageProtocol
  private var items = [RecentSearchListItemViewModelProtocol]()
  
  init(recentSearchStorage: RecentSearchStorageProtocol) {
    self.recentSearchStorage = recentSearchStorage
    self.items = recentSearchStorage.getSavedItems()
  }
  
  func numberOfItems() -> Int {
    return items.count
  }
  
  func item(at indexPath: IndexPath) -> RecentSearchListItemViewModelProtocol {
    return items[indexPath.row]
  }
  
  func deleteItem(at indexPath: IndexPath) {
    recentSearchStorage.deleteItem(items[indexPath.row])
    items.remove(at: indexPath.row)
  }
  
}
