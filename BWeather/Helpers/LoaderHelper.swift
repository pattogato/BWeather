//
//  LoaderHelper.swift
//  BWeather
//
//  Created by Bence Pattogato on 31/03/17.
//  Copyright © 2017 bence.pattogato. All rights reserved.
//

import Foundation
import SVProgressHUD

final class LoaderHelper {
  
  static func showLoader(title: String = "loading".localized) {
    SVProgressHUD.show(withStatus: title)
  }
  
  static func dismissLoader() {
    SVProgressHUD.dismiss()
  }
  
}
