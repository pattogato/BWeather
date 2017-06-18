//
//  RecentSearchModel.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 06. 16..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import Foundation

final class RecentSearchModel: NSObject, RecentSearchListItemViewModelProtocol {
  
  var name: String
  var extraInfo: String
  var id: String
  
  init(name: String, extraInfo: String, id: String?) {
    self.name = name
    self.extraInfo = extraInfo
    self.id = id ?? NSUUID().uuidString
  }
  
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(id, forKey: "id")
    aCoder.encode(extraInfo, forKey: "extraInfo")
    aCoder.encode(name, forKey: "name")
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    let id = aDecoder.decodeObject(forKey: "id") as! String
    let extraInfo = aDecoder.decodeObject(forKey: "extraInfo") as! String
    let name = aDecoder.decodeObject(forKey: "name") as! String
    self.init(name: name, extraInfo: extraInfo, id: id)
  }

  
}
