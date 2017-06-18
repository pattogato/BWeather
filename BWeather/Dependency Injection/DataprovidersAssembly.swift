//
//  DataprovidersAssemby.swift
//  BWeather
//
//  Created by Bence Pattogato on 28/03/17.
//  Copyright © 2017 bence.pattogato. All rights reserved.
//

import Foundation
import Swinject


final class  DataprovidersAssembly: Assembly {
  
  func assemble(container: Container) {
    container.register(RecentSearchListDataProviderProtocol.self) { r in
      return RecentSearchListDataProvider(
        recentSearchStorage: r.resolve(RecentSearchStorageProtocol.self)!
      )
    }
    
    container.register(SearchDataProviderProtocol.self) { r in
      return SearchDataProvider(
        weatherService: r.resolve(WeatherServiceProtocol.self)!,
        recentStorage: r.resolve(RecentSearchStorageProtocol.self)!
      )
    }
  }
  
}
