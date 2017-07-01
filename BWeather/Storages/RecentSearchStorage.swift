//
//  RecentSearchStorage.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 06. 05..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import Foundation

protocol RecentSearchStorageProtocol {
  func saveItem(_ item: RecentSearchListItemViewModelProtocol)
  func getSavedItems() -> [RecentSearchListItemViewModelProtocol]
  func deleteItem(_ item: RecentSearchListItemViewModelProtocol)
  func wipeStorage()
  
  var preferredUnit: Units { get set }
  var preferredTemperatureUnit: TemperatureUnit { get set }
}

final class RecentSearchStorage: RecentSearchStorageProtocol {
  
  private let searchPrefix: String
  
  private var recentSearchesKey: String {
    get {
      return searchPrefix + "recentSearchKey"
    }
  }
  
  private var unitKey: String {
    get {
      return searchPrefix + "unitKey"
    }
  }
  
  private var temperatureUnitKey: String {
    get {
      return searchPrefix + "tempUnitKey"
    }
  }
  
  private let defaultUnit: Units = .metric
  private let defaultTemperatureUnit: TemperatureUnit = .celsius
  
  private var defaults: UserDefaults {
    return .standard
  }
  
  init(searchPrefix: String) {
    self.searchPrefix = searchPrefix
  }
  
  func saveItem(_ item: RecentSearchListItemViewModelProtocol) {
    var savedItems = getSavedItems()
    savedItems = savedItems.filter({ $0.name != item.name })
    savedItems.insert(item, at: 0)
    saveItemList(items: savedItems)
  }
  
  func getSavedItems() -> [RecentSearchListItemViewModelProtocol] {
    if let decoded = defaults.object(forKey: recentSearchesKey) as? Data {
      return NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [RecentSearchListItemViewModelProtocol]
    }
    return [RecentSearchListItemViewModelProtocol]()
  }
  
  func deleteItem(_ item: RecentSearchListItemViewModelProtocol) {
    saveItemList(
      items: getSavedItems()
        .filter({ $0.id != item.id })
    )
  }
  
  func wipeStorage() {
    saveItemList(items: [RecentSearchListItemViewModelProtocol]())
  }
  
  var preferredUnit: Units {
    get {
      if let savedInt = defaults.value(forKey: unitKey) as? Int {
        return Units(rawValue: savedInt) ?? defaultUnit
      }
      return defaultUnit
    }
    
    set {
      defaults.set(newValue.rawValue, forKey: unitKey)
      defaults.synchronize()
    }
  }
  
  var preferredTemperatureUnit: TemperatureUnit {
    get {
      if let savedInt = defaults.value(forKey: temperatureUnitKey) as? Int {
        return TemperatureUnit(rawValue: savedInt) ?? defaultTemperatureUnit
      }
      return defaultTemperatureUnit
    }
    
    set {
      defaults.set(newValue.rawValue, forKey: temperatureUnitKey)
      defaults.synchronize()
    }
  }
  
  private func saveItemList(items: [RecentSearchListItemViewModelProtocol]) {
    let encodedData = NSKeyedArchiver.archivedData(withRootObject: items)
    defaults.set(encodedData, forKey: recentSearchesKey)
    defaults.synchronize()
  }
}
