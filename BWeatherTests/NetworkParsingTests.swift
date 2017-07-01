//
//  NetworkParsingTests.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 07. 01..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import XCTest

class NetworkParsingTests: XCTestCase {
  
  func testParseWeatherNetworkModel() {
    do {
      let jsonData = try readJson(fileName: "WeatherNetworkModelSampleData")
      guard let networkModel = CurrentWeatherNetworkModel(JSON: jsonData) else {
        XCTFail("CurrentWeatherNetworkModel parsing failed")
        return
      }
      
      // Assert models
      XCTAssertNotNil(networkModel)
      XCTAssertNotNil(networkModel.coordinates)
      XCTAssertNotNil(networkModel.weather?.first)
      XCTAssertNotNil(networkModel.mainValues)
      XCTAssertNotNil(networkModel.wind)
      XCTAssertNotNil(networkModel.clouds)
      XCTAssertNotNil(networkModel.extraInfo)
      
      // Assert current model values
      XCTAssertEqual(networkModel.base, "stations")
      XCTAssertEqual(networkModel.visiblity, 16093)
      XCTAssertEqual(networkModel.date, Date(timeIntervalSince1970: 1485788160))
      XCTAssertEqual(networkModel.id, "5375480")
      XCTAssertEqual(networkModel.name, "Mountain View")
      
      // Assert coordinate model values
      XCTAssertEqual(networkModel.coordinates?.lat, 37.39)
      XCTAssertEqual(networkModel.coordinates?.lat, -122.08)
      
      // Assert WeatherNetworkModel
      XCTAssertEqual(networkModel.weather?.first?.id, 500)
      XCTAssertEqual(networkModel.weather?.first?.main, "Rain")
      XCTAssertEqual(networkModel.weather?.first?.icon, "10n")
      XCTAssertEqual(networkModel.weather?.first?.desc, "light rain")
      
      // Assert WeatherMainValuesNetworkModel
      XCTAssertEqual(networkModel.mainValues?.humidity, 86)
      XCTAssertEqual(networkModel.mainValues?.temp, 277.14)
      XCTAssertEqual(networkModel.mainValues?.pressure, 1025)
      XCTAssertEqual(networkModel.mainValues?.tempMax, 279.15)
      XCTAssertEqual(networkModel.mainValues?.tempMin, 275.15)
      
      // Assert WindValueNetworkModel
      XCTAssertEqual(networkModel.wind?.degree, 53.005)
      XCTAssertEqual(networkModel.wind?.speed, 1.67)
      
      // Assert CloudsNetworkModel
      XCTAssertEqual(networkModel.clouds?.all, "1")
      
      // Assert ExtraWeatherInfoNetworkModel
      XCTAssertEqual(networkModel.extraInfo?.country, "US")
      XCTAssertEqual(networkModel.extraInfo?.sunrise, Date(timeIntervalSince1970: 1485789140))
      XCTAssertEqual(networkModel.extraInfo?.sunset, Date(timeIntervalSince1970: 1485826300))
    } catch let error {
      print(error)
    }
  }
  
  /// https://stackoverflow.com/questions/40438784/read-json-file-with-swift-3
  private func readJson(fileName: String) throws -> [String: Any] {
    if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
      let data = try Data(contentsOf: file)
      let json = try JSONSerialization.jsonObject(with: data, options: [])
      if let object = json as? [String: Any] {
        return object
      } else {
        throw ParseError.invalidJSON
      }
    } else {
      throw ParseError.fileNotFound
    }
  }
  
}
