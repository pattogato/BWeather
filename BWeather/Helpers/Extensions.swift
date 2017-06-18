//
//  Extensions.swift
//  BWeather
//
//  Created by Bence Pattogato on 25/03/17.
//  Copyright © 2017 bence.pattogato. All rights reserved.
//

import UIKit

extension String {
  
  var localized: String {
    return NSLocalizedString(self, tableName: "Localizable", bundle: Bundle.main, value: "", comment: "")
  }
  
  var isNumeric : Bool {
    get{
      return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
  }
  
}
