//
//  DataProviderTests.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 07. 02..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import XCTest
import RxSwift

class DataProviderTests: XCTestCase {
  
  private var recentSearchDataProvider: RecentSearchListDataProviderProtocol!
  private var searchDataProvider: SearchDataProviderProtocol!
  private var disposeBag = DisposeBag()
  private let networkTimeout: TimeInterval = 10.0
  
  override func setUp() {
    super.setUp()
    
    recentSearchDataProvider = DIManager.resolve(service: RecentSearchListDataProviderProtocol.self)
    searchDataProvider = DIManager.resolve(service: SearchDataProviderProtocol.self)
    recentSearchDataProvider.wipeRecentHistory()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  /// Seach for a place & check if it is added to the recents list
  func testAddRecentItem() {
    XCTAssertTrue(recentSearchDataProvider.numberOfItems() == 0)
    let expect = expectation(description: "Search expectation")
    searchDataProvider.search(for: "Budapest").subscribe(onNext: { (item) in
      XCTAssertTrue(self.recentSearchDataProvider.numberOfItems() == 1)
      XCTAssertTrue(self.recentSearchDataProvider.item(at: IndexPath(row: 0, section: 0)).name == item.city)
      expect.fulfill()
    }).addDisposableTo(disposeBag)
    waitForExpectations(timeout: networkTimeout, handler: nil)
  }
  
  /// Search for the same text twice, it should be added to recents only once
  func testAddSameRecentItemTwice() {
    XCTAssertTrue(recentSearchDataProvider.numberOfItems() == 0)
    let expect = expectation(description: "Search expectation")
    searchDataProvider.search(for: "Budapest").subscribe(onNext: { (item) in
      XCTAssertTrue(self.recentSearchDataProvider.numberOfItems() == 1)
      XCTAssertTrue(self.recentSearchDataProvider.item(at: IndexPath(row: 0, section: 0)).name == item.city)
      
      self.searchDataProvider.search(for: "Budapest").subscribe(onNext: { (item) in
        XCTAssertTrue(self.recentSearchDataProvider.numberOfItems() == 1)
        XCTAssertTrue(self.recentSearchDataProvider.item(at: IndexPath(row: 0, section: 0)).name == item.city)
        expect.fulfill()
      }).addDisposableTo(self.disposeBag)
      
    }).addDisposableTo(disposeBag)
    waitForExpectations(timeout: networkTimeout, handler: nil)
  }
  
  /// Search for a location & check wether the loadMostRecent function returns it
  func testLoadMostRecentLocation() {
    let expect = expectation(description: "Search expectation")
    searchDataProvider.search(for: "Budapest").subscribe(onNext: { (item) in
      self.searchDataProvider.loadMostRecentLocation().subscribe(onNext: { (lastItem) in
        XCTAssertEqual(item.city, lastItem.city)
        expect.fulfill()
      }).addDisposableTo(self.disposeBag)
    }).addDisposableTo(disposeBag)
    waitForExpectations(timeout: networkTimeout, handler: nil)
  }

  
}
