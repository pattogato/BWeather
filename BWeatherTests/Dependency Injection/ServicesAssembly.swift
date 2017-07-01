//
//  ServicesAssembly.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 07. 01..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import Foundation
import Swinject

final class ServicesAssembly: Assembly {
  
  func assemble(container: Container) {
    // Resolve weather service protocol with the same implementation as the application target
    container.register(WeatherServiceProtocol.self) { r in
      return WeatherService(recentStorage: r.resolve(RecentSearchStorageProtocol.self)!)
    }
  }
}
