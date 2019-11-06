//
//  Locator.swift
//  Map Duck
//
//  Created by Idan Birman on 24/10/2019.
//  Copyright © 2019 Idan Birman. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation


class Locator: NSObject, CLLocationManagerDelegate, ObservableObject {
    var objectWillChange = PassthroughSubject<Locator,Never>()
    
    let locationManager = CLLocationManager()
    
    var lastLocation : CLLocation? {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var latitude : Double? {
        if lastLocation == nil {return nil}
        return Double(lastLocation!.coordinate.latitude).rounded(toPlaces: 2)
    }
    
    var longitude : Double? {
        if lastLocation == nil {return nil}
        return Double(lastLocation!.coordinate.longitude).rounded(toPlaces: 2)
    }
    
    override var description: String {
        return "\(latitude ?? -1.0) , \(longitude ?? -1.0)"
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           self.lastLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("resumed")
    }
    
    func locate() {
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        } else {
            print("no permission")
        }
    }
    
    func start() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            print("no permission")
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

