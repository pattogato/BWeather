//
//  PersistanceManager.swift
//  BWeather
//
//  Created by Bence Pattogato on 03/04/17.
//  Copyright © 2017 bence.pattogato. All rights reserved.
//

import Foundation

protocol PersistanceManagerProtocol {
}

final class PersistanceManager: PersistanceManagerProtocol {
  
  private var defaults: UserDefaults {
    return .standard
  }
  
//  func saveCartItems(items: [ShoppableItem]) {
//    let encodedData = NSKeyedArchiver.archivedData(withRootObject: items)
//    defaults.set(encodedData, forKey: cartKey)
//    defaults.synchronize()
//  }
//  
//  func getSavedItems() -> [ShoppableItem]? {
//    if let decoded = defaults.object(forKey: cartKey) as? Data {
//      return NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [ShoppableItem]
//    }
//    return nil
//  }
  
}
