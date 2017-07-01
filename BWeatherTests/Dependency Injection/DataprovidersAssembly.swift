//
//  DataprovidersAssembly.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 07. 01..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import Foundation
import Swinject


final class  DataprovidersAssembly: Assembly {
  
  func assemble(container: Container) {
    // Resolve recent search list data procider protocol for testing purposes
    container.register(RecentSearchListDataProviderProtocol.self) { r in
      return RecentSearchListDataProvider(
        recentSearchStorage: r.resolve(RecentSearchStorageProtocol.self)!
      )
    }
    
    // Resolve SearchDataProviderProtocol
    container.register(SearchDataProviderProtocol.self) { r in
      return SearchDataProvider(
        weatherService: r.resolve(WeatherServiceProtocol.self)!,
        recentStorage: r.resolve(RecentSearchStorageProtocol.self)!
      )
    }
  }
  
}
