//
//  ServiceResources.swift
//  BWeather
//
//  Created by Bence Pattogato on 29/03/17.
//  Copyright © 2017 bence.pattogato. All rights reserved.
//

import Foundation
import Alamofire

struct ServiceResources {
  static let baseUrl = "http://api.openweathermap.org/data/2.5/"
  static let imagePath = ServiceResources.baseUrl + "img/w/"
  static let appId = "95d190a434083879a6398aafd54d9e73"
  static let maxRetryCount: Int = 3
  
  static let baseParams: [String: Any] = [ParameterNames.appId.name: ServiceResources.appId]
  
  enum ParameterNames {
    case keyword
    case appId
    case zip
    case units
    
    var name: String {
      switch self {
      case .keyword:
        return "q"
      case .appId:
        return "appid"
      case .zip:
        return "zip"
      case .units:
        return "units"
      }
    }
  }
}
