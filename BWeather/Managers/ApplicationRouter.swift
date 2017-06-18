//
//  ApplicationRouter.swift
//  BWeather
//
//  Created by Bence Pattogato on 28/03/17.
//  Copyright © 2017 bence.pattogato. All rights reserved.
//

import Foundation
import UIKit

protocol ApplicationRouterProtocol {
  func start()
  
  func change(rootViewController: UIViewController)
  func showViewController(ofType type: ViewControllers)
  func viewController(ofType type: ViewControllers) -> UIViewController
}

final class ApplicationRouter: ApplicationRouterProtocol {
  private let storyboards: [Storyboards: UIStoryboard]
  private let window: UIWindow
  
  init(window: UIWindow, storyboards: [Storyboards: UIStoryboard]) {
    self.window = window
    self.storyboards = storyboards
  }
  
  private func route() {
    showViewController(ofType: .searchNavigation)
  }
  
  func start() {
    route()
  }
  
  func showViewController(ofType type: ViewControllers) {
    change(rootViewController: viewController(ofType: type))
  }
  
  func change(rootViewController: UIViewController) {
    window.rootViewController = rootViewController
  }
  
  func viewController(ofType type: ViewControllers) -> UIViewController {
    let storyboard = self.storyboards[type.storyboard]
    assert(storyboard != nil, "Storyboard should be registered before first use.")
    return storyboard!.instantiateViewController(withIdentifier: type.identifier)
  }
}
