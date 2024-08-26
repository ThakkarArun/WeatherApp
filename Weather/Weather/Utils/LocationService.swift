//
//  File.swift
//  Weather
//
//  Created by Arun  Thakkar on 8/25/24.
//

import Foundation
import CoreLocation
import Combine

class LocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
    public let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var locationSubject = PassthroughSubject<CLLocation, Never>()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // Ensure the correct method is called
    }
    
    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
            locationSubject.send(location)
        }
    }
    
    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        // If authorized, you can request location updates
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}

