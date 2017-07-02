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
  
  func testHexUIColorInit() {
    XCTAssertEqual(UIColor(hex: "#0000ff"), UIColor.blue)
    XCTAssertEqual(UIColor(hex: "#ff0000"), UIColor.red)
    XCTAssertEqual(UIColor(hex: "00ff00"), UIColor.green)
    XCTAssertNil(UIColor(hex: "#00000"))
    XCTAssertNil(UIColor(hex: "#00000345"))
  }
}
