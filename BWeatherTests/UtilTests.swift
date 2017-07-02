//
//  UtilTests.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 07. 02..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import XCTest

class UtilTests: XCTestCase {
  
  func testIsNumericStringExtension() {
    XCTAssertTrue("12345".isNumeric)
    XCTAssertFalse("12345a".isNumeric)
    XCTAssertFalse("Qwerasdf".isNumeric)
    XCTAssertTrue("0.12345231".isNumeric)
    XCTAssertFalse("0.1234.5231".isNumeric)
  }
    
}
