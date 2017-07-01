//
//  StoragesAssembly.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 07. 01..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import Foundation
import Swinject

final class StoragesAssembly: Assembly {
  
  func assemble(container: Container) {
    // Resolve recent storage protocol implementation
    // With the objectscope .container it will be singleton
    container.register(RecentSearchStorageProtocol.self) { r in
      return RecentSearchStorage(searchPrefix: "testRecent")
    }.inObjectScope(.container)
  }
  
}
