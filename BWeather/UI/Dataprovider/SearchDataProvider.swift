//
//  SearchDataProvider.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 06. 05..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

enum SearchError: Error {
  case NoRecent
}

final class SearchDataProvider: SearchDataProviderProtocol {
  
  private let weatherService: WeatherServiceProtocol
  private let recentStorage: RecentSearchStorageProtocol
  private lazy var locationManager: CLLocationManager = {
    return CLLocationManager()
  }()
  
  init(weatherService: WeatherServiceProtocol, recentStorage: RecentSearchStorageProtocol) {
    self.weatherService = weatherService
    self.recentStorage = recentStorage
  }
  
  func search(for text: String) -> Observable<CurrentWeatherViewModelProtocol> {
    return weatherService
      .getCurrentWeather(keyword: text)
      .map({
        self.recentStorage.saveItem(RecentSearchModel(name: $0.name ?? text , extraInfo: $0.extraInfo?.country ?? "", id: nil))
        return WeatherViewModel(
          networkModel: $0,
          unit: self.recentStorage.preferredUnit,
          temperatureUnit: self.recentStorage.preferredTemperatureUnit)
      })
  }
  
  func searchFor(zip: String, country: String) -> Observable<CurrentWeatherViewModelProtocol> {
    return weatherService
      .getCurrentWeather(zipCode: zip, country: country)
      .map({
        self.recentStorage.saveItem(RecentSearchModel(name: $0.name ?? zip, extraInfo: $0.extraInfo?.country ?? "", id: nil))
        return WeatherViewModel(
          networkModel: $0,
          unit: self.recentStorage.preferredUnit,
          temperatureUnit: self.recentStorage.preferredTemperatureUnit)
      })
  }
  
  func searchForLocation() -> Observable<CurrentWeatherViewModelProtocol> {
    locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
    let currentLocation = locationManager.rx.didUpdateLocations
      .map { locations in
        return locations[0]
      }
      .filter { location in
        return location.horizontalAccuracy < kCLLocationAccuracyHundredMeters
    }
    
    return currentLocation.take(1).flatMap({ location in
      return self.weatherService
        .getCurrentWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        .map({
          self.recentStorage.saveItem(RecentSearchModel(name: $0.name ?? "", extraInfo: $0.extraInfo?.country ?? "", id: nil))
          return WeatherViewModel(
            networkModel: $0,
            unit: self.recentStorage.preferredUnit,
            temperatureUnit: self.recentStorage.preferredTemperatureUnit)
        })
    })
  }
  
  func loadMostRecentLocation() -> Observable<CurrentWeatherViewModelProtocol> {
    if let mostRecent = self.recentStorage.getSavedItems().first {
      return self.search(for: mostRecent.name)
    }
    return Observable.error(SearchError.NoRecent)
  }
  
}

fileprivate struct WeatherViewModel: CurrentWeatherViewModelProtocol {
  var city: String
  var shortDescription: String
  var country: String
  var currentTemperature: String
  var moreInfo: [(title: String, info: String)]
  var imageUrl: URL?
  
  init(networkModel: CurrentWeatherNetworkModel, unit: Units, temperatureUnit: TemperatureUnit) {
    self.city = networkModel.name ?? "current.city.unknown".localized
    self.shortDescription = networkModel.weather?.first?.main ?? "current.cloud.unknown".localized
    self.country = networkModel.extraInfo?.country ?? "current.country.unknown".localized
    self.currentTemperature = temperatureUnit.temp(value: round((networkModel.mainValues?.temp ?? 0) * 10 / 10))
    self.moreInfo = [(title: String, info: String)]()
    if let imagePath = networkModel.weather?.first?.icon {
      self.imageUrl = constructImageUrl(imageName: imagePath)
    }
    
    if let tempMin = networkModel.mainValues?.tempMin {
      moreInfo.append((
        title: "current.tempmin".localized,
        info: temperatureUnit.temp(value: tempMin)
      ))
    }
    if let tempMax = networkModel.mainValues?.tempMax {
      moreInfo.append((
        title: "current.tempmax".localized,
        info: temperatureUnit.temp(value: tempMax)
      ))
    }
    if let desc = networkModel.weather?.first?.desc {
      moreInfo.append((
        title: "current.description".localized,
        info: desc
      ))
    }
    if let pressure = networkModel.mainValues?.pressure {
      moreInfo.append((
        title: "current.pressure".localized,
        info: String(pressure)
      ))
    }
    if let humidity = networkModel.mainValues?.humidity {
      moreInfo.append((
        title: "current.humidity".localized,
        info: String(humidity) + " %"
      ))
    }
    if let windSpeed = networkModel.wind?.speed {
      moreInfo.append((
        title: "current.windspeed".localized,
        info: unit.speed(value: windSpeed)
      ))
    }
    if let visibility = networkModel.visiblity {
      moreInfo.append((
        title: "current.visiblity".localized,
        info: unit.distance(value: visibility)
      ))
    }
    
  }
  
  private func constructImageUrl(imageName: String) -> URL? {
    return URL(string: ServiceResources.imagePath + imageName)
  }
}
