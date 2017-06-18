//
//  ServicesAssembly.swift
//  BWeather
//
//  Created by Bence Pattogato on 28/03/17.
//  Copyright © 2017 bence.pattogato. All rights reserved.
//

import Foundation
import Swinject

final class ServicesAssembly: Assembly {
  
  func assemble(container: Container) {
    
    container.register(WeatherServiceProtocol.self) { r in
      return WeatherService(
        recentStorage: r.resolve(RecentSearchStorageProtocol.self)!
      )
    }
    
  }
}
