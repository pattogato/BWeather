//
//  NetworkModels.swift
//  BWeather
//
//  Created by Bence Pattogato on 29/03/17.
//  Copyright © 2017 bence.pattogato. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 These classes are responsible to map the JSON files from the network to local object models
 */

enum Units: Int {
  case metric
  
  func distance(value: Double) -> String {
    switch self {
    case .metric:
      return String(value) + " m"
    }
  }
  
  func speed(value: Double) -> String {
    switch self {
    case .metric:
      return String(value) + " m/s"
    }
  }
}

enum TemperatureUnit: Int {
  case celsius
  case fahrenheit
  case kelvin
  
  func temp(value: Double) -> String {
    let valueString = String(value)
    switch self {
    case .celsius:
      return valueString + "°C"
    case .fahrenheit:
      return valueString + "°F"
    case .kelvin:
      return valueString + "K"
    }
  }
}

struct CurrentWeatherNetworkModel: Mappable {
  
  var coordinates: CoordinateNetworkModel?
  var weather: [WeatherNetworkModel]?
  var base: String?
  var mainValues: WeatherMainValuesNetworkModel?
  var visiblity: Double?
  var wind: WindValueNetworkModel?
  var clouds: CloudsNetworkModel?
  var date: Date?
  var extraInfo: ExtraWeatherInfoNetworkModel?
  var id: String?
  var name: String?
  
  mutating func mapping(map: Map) {
    coordinates <- map["coordinates"]
    weather <- map["weather"]
    base <- map["base"]
    mainValues <- map["main"]
    visiblity <- map["visibility"]
    wind <- map["wind"]
    clouds <- map["clouds"]
    date <- (map["birthday"], DateTransform())
    extraInfo <- map["sys"]
    id <- map["id"]
    name <- map["name"]
  }
  
  init?(map: Map) { }
  
}

struct CoordinateNetworkModel: Mappable {
  
  var lon: Double?
  var lat: Double?
  
  mutating func mapping(map: Map) {
    lon <- map["lon"]
    lat <- map["lat"]
  }
  
  init?(map: Map) { }
  
}

struct WeatherNetworkModel: Mappable {
  
  var id: Int?
  var main: String?
  var desc: String?
  var icon: String?
  
  mutating func mapping(map: Map) {
    id <- map["id"]
    main <- map["main"]
    desc <- map["description"]
    icon <- map["icon"]
  }
  
  init?(map: Map) { }
  
}

struct WeatherMainValuesNetworkModel: Mappable {
  var temp: Double?
  var pressure: Double?
  var humidity: Double?
  var tempMin: Double?
  var tempMax: Double?
  
  mutating func mapping(map: Map) {
    temp <- map["temp"]
    pressure <- map["pressure"]
    humidity <- map["humidity"]
    tempMin <- map["tempMin"]
    tempMax <- map["tempMax"]
  }
  
  init?(map: Map) { }
  
}

struct WindValueNetworkModel: Mappable {
  var speed: Double?
  var degree: Double?
  
  mutating func mapping(map: Map) {
    speed <- map["speed"]
    degree <- map["deg"]
  }
  
  init?(map: Map) { }
  
}

struct CloudsNetworkModel: Mappable {
  var all: String?
  
  mutating func mapping(map: Map) {
    all <- map["all"]
  }
  
  init?(map: Map) { }
}

struct ExtraWeatherInfoNetworkModel: Mappable {
  var country: String?
  var sunrise: Date?
  var sunset: Date?
  
  mutating func mapping(map: Map) {
    country <- map["country"]
    sunrise <- map["sunrise"]
    sunset <- map["sunset"]
  }
  
  init?(map: Map) { }
}

