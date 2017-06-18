//
//  StoragesAssembly.swift
//  BWeather
//
//  Created by Bence Pattogato on 28/03/17.
//  Copyright © 2017 bence.pattogato. All rights reserved.
//

import Foundation
import Swinject

final class StoragesAssembly: Assembly {
  
  func assemble(container: Container) {
    container.register(RecentSearchStorageProtocol.self) { r in
      return RecentSearchStorage()
    }
  }
  
}
