//
//  ApplicationAssembly.swift
//  BWeather
//
//  Created by Bence Pattogato on 28/03/17.
//  Copyright © 2017 bence.pattogato. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

final class ApplicationAssembly: Assembly {
  
  func assemble(container: Container) {
    registerWindow(container: container)
    registerStoryboards(container: container)
    registerViewControllers(container: container)
  }
  
  private func registerStoryboards(container: Container) {
    Storyboards.all().forEach {
      storyboard in
      
      container.register(
        UIStoryboard.self,
        name: storyboard.name,
        factory: { (r) -> UIStoryboard in
          SwinjectStoryboard.create(
            name: storyboard.name,
            bundle: nil,
            container: container)
      }).inObjectScope(.container)
    }
  }
  
  private func registerWindow(container: Container) {
    container.register(UIWindow.self) { (r) -> UIWindow in
      let window = UIWindow(frame: UIScreen.main.bounds)
      window.makeKeyAndVisible()
      return window
      }.inObjectScope(.container)
  }
  
  private func registerViewControllers(container: Container) {
    container.storyboardInitCompleted(RecentSearchListTableViewController.self) { r, c in
      c.dataProvider = r.resolve(RecentSearchListDataProviderProtocol.self)
    }
    
    container.storyboardInitCompleted(SearchViewController.self) { r, c in
      c.dataProvider = r.resolve(SearchDataProviderProtocol.self)
    }
  }
  
}

