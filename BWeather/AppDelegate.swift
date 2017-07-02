//
//  AppDelegate.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 06. 02..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Load application window
    window = DIManager.resolve(service: UIWindow.self)
    DIManager.resolve(service: ApplicationRouterProtocol.self).start()
    
    setupAppearances()
    
    return true
  }
  
  private func setupAppearances() {
    UIApplication.shared.keyWindow?.tintColor = UIColor.colorSchema
  }
  
}


