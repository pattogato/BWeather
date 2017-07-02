//
//  RecentSearchListDataProvider.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 06. 05..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import Foundation

protocol RecentSearchListDataProviderProtocol {
  func numberOfItems() -> Int
  func item(at indexPath: IndexPath) -> RecentSearchListItemViewModelProtocol
  func deleteItem(at indexPath: IndexPath)
  
  func wipeRecentHistory()
}

protocol RecentSearchListItemViewModelProtocol: NSCoding {
  var name: String { get }
  var extraInfo: String { get }
  var id: String { get }
}

func ==(lhs: RecentSearchListItemViewModelProtocol, rhs: RecentSearchListItemViewModelProtocol) -> Bool {
  return lhs.id == rhs.id
}

final class RecentSearchListDataProvider: RecentSearchListDataProviderProtocol {
  
  private let recentSearchStorage: RecentSearchStorageProtocol
  private var items: [RecentSearchListItemViewModelProtocol] {
    get {
      return recentSearchStorage.getSavedItems()
    }
  }
  
  init(recentSearchStorage: RecentSearchStorageProtocol) {
    self.recentSearchStorage = recentSearchStorage
  }
  
  func numberOfItems() -> Int {
    return items.count
  }
  
  func item(at indexPath: IndexPath) -> RecentSearchListItemViewModelProtocol {
    return items[indexPath.row]
  }
  
  func deleteItem(at indexPath: IndexPath) {
    recentSearchStorage.deleteItem(items[indexPath.row])
  }
  
  func wipeRecentHistory() {
    recentSearchStorage.wipeStorage()
  }
  
}
