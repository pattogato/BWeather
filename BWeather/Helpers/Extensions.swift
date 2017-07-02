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
      return Double(self) != nil
    }
  }
  
}

extension UIColor {
  
  /// Returns the given color scheme, or default blue if not set properly
  static var colorSchema: UIColor {
    var myDict: NSDictionary?
    if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
      myDict = NSDictionary(contentsOfFile: path)
    }
    if let hexString = myDict?["Color schema"] as? String {
      return UIColor(hex: hexString) ?? .blue
    }
    
    return .blue
  }
  
  /// source: https://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
  convenience init?(hex: String) {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
      cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
      return nil
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    self.init(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )

  }
  
}
