//
//  WeatherEndpoints.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 06. 05..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import Foundation

import Foundation
import Moya

enum WeatherEndpoints {
  case currentWeatherByKeyword(keyword: String, units: Units)
  case currentWeatherByZip(zip: String, units: Units)
  case currentWeatherByLocation(lat: Double, long: Double, units: Units)
}

extension WeatherEndpoints: TargetType {
  
  var baseURL: URL {
    return URL(string: ServiceResources.baseUrl)!
  }
  
  var path: String {
    switch self {
    case .currentWeatherByKeyword, .currentWeatherByZip, .currentWeatherByLocation:
      return "weather"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .currentWeatherByKeyword, .currentWeatherByZip, .currentWeatherByLocation:
      return .get
    }
  }
  
  var task: Task {
    return .request
  }
  
  var validate: Bool {
    return true
  }
  
  var parameters: [String: Any]? {
    var params = ServiceResources.baseParams
    let unitsParam: Units
    switch self {
    case .currentWeatherByKeyword(let keyword, let units):
      params.updateValue(keyword, forKey: ServiceResources.ParameterNames.keyword.name)
      unitsParam = units
    case .currentWeatherByZip(let zip, let units):
      params.updateValue(zip, forKey: ServiceResources.ParameterNames.zip.name)
      unitsParam = units
    case .currentWeatherByLocation(let lat, let long, let units):
      params.updateValue(lat, forKey: ServiceResources.ParameterNames.lat.name)
      params.updateValue(long, forKey: ServiceResources.ParameterNames.lon.name)
      unitsParam = units
    }
    params.updateValue(unitsParam, forKey: ServiceResources.ParameterNames.units.name)
    
    return params
  }
  
  var parameterEncoding: ParameterEncoding {
    return URLEncoding.default
  }
  
  /// Provides stub data for use in testing.
  public var sampleData: Data {
    return Data()
  }
  
}
