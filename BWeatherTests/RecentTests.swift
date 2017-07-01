//
//  RecentTests.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 07. 01..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import XCTest

class RecentTests: XCTestCase {
  
  private var recentStorage: RecentSearchStorageProtocol!
  var randomString: String {
    get {
      return "recent item" + String(arc4random())
    }
  }
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    recentStorage = DIManager.resolve(service: RecentSearchStorageProtocol.self)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    recentStorage.wipeStorage()
    super.tearDown()
  }
  
  func testSaveRecentItem() {
    let sampleItem = createSampleItem()
    XCTAssertTrue(recentStorage.getSavedItems().count == 0)
    recentStorage.saveItem(sampleItem)
    XCTAssertTrue(recentStorage.getSavedItems().count == 1)
  }
  
  func testRemoveRecentItem() {
    let sampleItem = createSampleItem()
    XCTAssertTrue(recentStorage.getSavedItems().count == 0)
    recentStorage.saveItem(sampleItem)
    XCTAssertTrue(recentStorage.getSavedItems().count == 1)
    recentStorage.deleteItem(sampleItem)
    XCTAssertTrue(recentStorage.getSavedItems().count == 0)
  }
  
  func testGetSavedItems() {
    let item1 = createSampleItem()
    let item2 = createSampleItem()
    let item3 = createSampleItem()
    recentStorage.saveItem(item1)
    recentStorage.saveItem(item2)
    recentStorage.saveItem(item3)
    XCTAssertTrue(recentStorage.getSavedItems().count == 3)
  }
  
  func testSavePreferredUnit() {
    recentStorage.preferredUnit = .metric
    XCTAssertTrue(recentStorage.preferredUnit == .metric)
  }
  
  func testSavePreferredTemperatureUnit() {
    recentStorage.preferredTemperatureUnit = .celsius
    XCTAssertTrue(recentStorage.preferredTemperatureUnit == .celsius)
    recentStorage.preferredTemperatureUnit = .fahrenheit
    XCTAssertTrue(recentStorage.preferredTemperatureUnit == .fahrenheit)
    recentStorage.preferredTemperatureUnit = .kelvin
    XCTAssertTrue(recentStorage.preferredTemperatureUnit == .kelvin)
  }
  
  private func createSampleItem() -> RecentSearchListItemViewModelProtocol {
    return RecentSearchModel(name: randomString, extraInfo: "us", id: nil)
  }
  
}
