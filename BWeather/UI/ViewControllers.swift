//
//  ViewControllers.swift
//  BWeather
//
//  Created by Bence Pattogato on 2017. 06. 02..
//  Copyright © 2017. Bence Pattogato. All rights reserved.
//

import Foundation

enum Storyboards {
  case main
  
  static func all() -> [Storyboards] {
    return [
      main
    ]
  }
  
  var name: String {
    switch self {
    case .main: return "Main"
    }
  }
}

enum ViewControllers {
  case recent
  case searchNavigation
  case search
  
  var storyboard: Storyboards {
    switch self {
    case .recent,
         .searchNavigation,
         .search:
      return .main
    }
  }
  
  var identifier: String {
    switch self {
    case .recent: return "RecentSearchListTableViewController"
    case .searchNavigation: return "SearchNavigationController"
    case .search: return "SearchViewController"
    }
  }
}
