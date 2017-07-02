//
//  RecentSearchStorage.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 06. 05..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import Foundation

protocol RecentSearchStorageProtocol {
  /// Saves an item to the persistent storage
  func saveItem(_ item: RecentSearchListItemViewModelProtocol)
  /// Returns all the saved items (uses a cach, that is invalidated on add/delete)
  func getSavedItems() -> [RecentSearchListItemViewModelProtocol]
  /// Removes an item from the persisten storage
  func deleteItem(_ item: RecentSearchListItemViewModelProtocol)
  /// Deletes all the saves items
  func wipeStorage()
  
  /// - set: saves the given Units to the persistent storage
  /// - get: returns the saved preferred Units
  var preferredUnit: Units { get set }
  /// - set: saves the give TemperatureUnit to the persistent storage
  /// - get: returns the saved preferred TemperatureUnit
  var preferredTemperatureUnit: TemperatureUnit { get set }
}

final class RecentSearchStorage: RecentSearchStorageProtocol {
  
  // MARK: - Properties
  private let searchPrefix: String
  private let defaultUnit: Units = .metric
  private let defaultTemperatureUnit: TemperatureUnit = .celsius
  private var cachedItems: [RecentSearchListItemViewModelProtocol]?
  // MARK: - Computed properties
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
    invalidateCache()
  }
  
  func getSavedItems() -> [RecentSearchListItemViewModelProtocol] {
    if cachedItems == nil {
      if let decoded = defaults.object(forKey: recentSearchesKey) as? Data {
        cachedItems = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [RecentSearchListItemViewModelProtocol]
      } else {
        cachedItems = [RecentSearchListItemViewModelProtocol]()
      }
    }
    return cachedItems!
  }
  
  func deleteItem(_ item: RecentSearchListItemViewModelProtocol) {
    saveItemList(
      items: getSavedItems()
        .filter({ $0.id != item.id })
    )
    invalidateCache()
  }
  
  func wipeStorage() {
    saveItemList(items: [RecentSearchListItemViewModelProtocol]())
    invalidateCache()
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
  
  private func invalidateCache() {
    cachedItems = nil
  }
  
}
