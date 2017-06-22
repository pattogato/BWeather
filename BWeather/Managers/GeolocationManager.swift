////
////  GeolocationManager.swift
////  BWeather
////
////  Created by Bence on 22/06/2017.
////  Copyright © 2017 Bence Pattogato. All rights reserved.
////
//
//import Foundation
//import CoreLocation
//import RxSwift
//import RxCocoa
//
//class GeolocationManager {
//    
//    static let sharedInstance = GeolocationManager()
//    private (set) var authorized: Driver<Bool>
//    private (set) var location: Driver<CLLocationCoordinate2D>
//    
//    private let locationManager = CLLocationManager()
//    private let disposeBag = DisposeBag()
//    
//    private init() {
//        locationManager.distanceFilter = kCLDistanceFilterNone;
//        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
//        
//        authorized = locationManager.rx.observe(<#T##type: E.Type##E.Type#>, <#T##keyPath: String##String#>)
//        
//        rx_didChangeAuthorizationStatus
//            .startWith(CLLocationManager.authorizationStatus())
//            .asDriver(onErrorJustReturn: CLAuthorizationStatus.NotDetermined)
//            .map {
//                switch $0 {
//                case .AuthorizedAlways:
//                    return true
//                default:
//                    return false
//                }
//        }
//        
//        location = locationManager.rx_didUpdateLocations
//            .asDriver(onErrorJustReturn: [])
//            .filter { $0.count > 0 }
//            .map { $0.last!.coordinate }
//        
//        location
//            .driveNext { [unowned self] _ in
//                self.locationManager.stopUpdatingLocation()
//            }
//            .addDisposableTo(disposeBag)
//        
//        locationManager.requestAlwaysAuthorization()
//        update()
//    }
//    
//    func update() {
//        locationManager.startUpdatingLocation()
//    }
//    
//}
