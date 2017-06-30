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
  /// Creates a request then executes it, to fetch weather info
  /// - Parameter keyword: the searched text
  func getCurrentWeather(keyword: String) -> Observable<CurrentWeatherNetworkModel>
  // Creates a request then executes it, to fetch weather info
  /// - Parameter zipCode: numeric String representing the postal code
  /// - Parameter country: two letter country name short form
  func getCurrentWeather(zipCode: String, country: String) -> Observable<CurrentWeatherNetworkModel>
  // Creates a request then executes it, to fetch weather info
  /// - Parameter lat: position's latitude
  /// - Parameter lat: position's longitude
  func getCurrentWeather(lat: Double, lon: Double) -> Observable<CurrentWeatherNetworkModel>
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
  
  func getCurrentWeather(lat: Double, lon: Double) -> Observable<CurrentWeatherNetworkModel> {
    return self.provider
      .request(.currentWeatherByLocation(lat: lat, long: lon, units: recentStorage.preferredUnit))
      .retry(ServiceResources.maxRetryCount)
      .mapObject(CurrentWeatherNetworkModel.self)
  }
  
}
