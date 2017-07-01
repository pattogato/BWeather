//
//  ParseTests.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 06. 30..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import XCTest
import ObjectMapper
import RxSwift

enum ParseError: Error {
  case invalidJSON
  case fileNotFound
}

class ParseTests: XCTestCase {
  
  private var weatherService: WeatherServiceProtocol!
  private var disposeBag = DisposeBag()
  private let networkTimeout: TimeInterval = 10.0
  
  override func setUp() {
    super.setUp()
    
    weatherService = DIManager.resolve(service: WeatherServiceProtocol.self)
  }
  
  override func tearDown() {
    
    
    super.tearDown()
  }
  
  func testValidKeywordSearch() {
    let expect = expectation(description: "Valid keyword search expectation")
    weatherService.getCurrentWeather(keyword: "Budapest")
      .subscribe(onNext: { (weatherModel) in
        XCTAssertNotNil(weatherModel)
        expect.fulfill()
      }).addDisposableTo(disposeBag)
    
    waitForExpectations(timeout: networkTimeout, handler: nil)
  }
  
  func testInvalidKeywordSearch() {
    let expect = expectation(description: "invalid keyword search expectation")
    weatherService.getCurrentWeather(keyword: "lgjdugjeiurghslieurglisuerhglisur")
      .subscribe { (event) in
        XCTAssertNotNil(event.error)
        expect.fulfill()
      }.addDisposableTo(disposeBag)
    
    waitForExpectations(timeout: networkTimeout, handler: nil)
  }
  
  func testValidZipSearch() {
    let expect = expectation(description: "Valid zip search expectation")
    weatherService.getCurrentWeather(zipCode: "1076", country: "hu")
      .subscribe(onNext: { (weatherModel) in
        XCTAssertNotNil(weatherModel)
        expect.fulfill()
      }).addDisposableTo(disposeBag)
    
    waitForExpectations(timeout: networkTimeout, handler: nil)
  }
  
  func testInvalidZipSearch() {
    let expect = expectation(description: "Invalid zip search expectation")
    weatherService.getCurrentWeather(zipCode: "1076", country: "us")
      .subscribe { (event) in
        XCTAssertNotNil(event.error)
        expect.fulfill()
      }.addDisposableTo(disposeBag)
    
    waitForExpectations(timeout: networkTimeout, handler: nil)
  }
  
  func testValidLocationSearch() {
    let expect = expectation(description: "Valid location search expectation")
    // Search for Budapest's location
    weatherService.getCurrentWeather(lat: 47.5, lon: 19.03)
      .subscribe(onNext: { (weatherModel) in
        XCTAssertNotNil(weatherModel)
        expect.fulfill()
      }).addDisposableTo(disposeBag)
    
    waitForExpectations(timeout: networkTimeout, handler: nil)
  }
  
  func testInvalidLocationSerach() {
    let expect = expectation(description: "Invalid location search expectation")
    weatherService.getCurrentWeather(lat: 250, lon: -300)
      .subscribe { (event) in
        XCTAssertNotNil(event.error)
        expect.fulfill()
      }.addDisposableTo(disposeBag)
    
    waitForExpectations(timeout: networkTimeout, handler: nil)
  }
}
