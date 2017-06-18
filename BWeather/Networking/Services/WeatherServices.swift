//
//  WeatherServices.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 06. 05..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import Foundation
import RxSwift
import Moya_ObjectMapper
import Moya

protocol WeatherServiceProtocol {
  
  func getCurrentWeather(keyword: String) -> Observable<CurrentWeatherNetworkModel>
  func getCurrentWeather(zipCode: String, country: String) -> Observable<CurrentWeatherNetworkModel>
}

// MARK: - MyDog Service implementation

final class WeatherService: WeatherServiceProtocol {
  
  // MARK: - Dependencies
  private let recentStorage: RecentSearchStorageProtocol
  
  init(recentStorage: RecentSearchStorageProtocol) {
    self.recentStorage = recentStorage
  }
  
  // MARK: - Properties
  private let provider = RxMoyaProvider<WeatherEndpoints>(plugins: [NetworkLoggerPlugin()])
  
  // MARK: - Courses Service
  
  func getCurrentWeather(keyword: String) -> Observable<CurrentWeatherNetworkModel> {
    return self.provider
      .request(.currentWeatherByKeyword(keyword: keyword, units: recentStorage.preferredUnit))
      .retry(ServiceResources.maxRetryCount)
      .mapObject(CurrentWeatherNetworkModel.self)
  }
  
  func getCurrentWeather(zipCode: String, country: String) -> Observable<CurrentWeatherNetworkModel> {
    let zipAndCountry = zipCode + "," + country
    return self.provider
      .request(.currentWeatherByZip(zip: zipAndCountry, units: recentStorage.preferredUnit))
      .retry(ServiceResources.maxRetryCount)
      .mapObject(CurrentWeatherNetworkModel.self)
  }
  
}
