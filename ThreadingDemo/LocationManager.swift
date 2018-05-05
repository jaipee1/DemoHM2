//
//  LocationManager.swift
//  ThreadingDemo
//
//  Created by Honey Maheshwari on 20/01/18.
//  Copyright © 2018 Honey Maheshwari. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationManagerDelegate {
    func locationManager(didFailWithError error: Error)
    func locationManager(didChangeAuthorization status: CLAuthorizationStatus)
    func locationManager(didUpdateLocations location: CLLocation)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    fileprivate var locationManager: CLLocationManager!
    fileprivate var location: CLLocation!
    fileprivate static let startUpdatingLocationWhenAuthorized = true
    var delegate: LocationManagerDelegate?
    
    class var currentLocation: CLLocation {
        get {
            if let location = shared.location {
                return location
            } else if let location = shared.locationManager.location {
                return location
            } else {
                return CLLocation(latitude: kCLLocationCoordinate2DInvalid.latitude, longitude: kCLLocationCoordinate2DInvalid.longitude)
            }
        }
    }
    
    class var currentCoordinate: CLLocationCoordinate2D {
        get {
            return currentLocation.coordinate
        }
    }
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    class func setLocationManagerDelegate(delegate: LocationManagerDelegate?) {
        shared.delegate = delegate
    }
    
    class func startMonitoringLocation() {
        shared.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        shared.locationManager.activityType = CLActivityType.otherNavigation
        shared.locationManager.distanceFilter = kCLDistanceFilterNone
        shared.locationManager.requestWhenInUseAuthorization()
        shared.locationManager.startMonitoringSignificantLocationChanges()
        shared.locationManager.startUpdatingLocation()
    }
    
    class func stopMonitoringLocation() {
        shared.locationManager.startMonitoringSignificantLocationChanges()
        shared.locationManager.stopUpdatingLocation()
    }
    
    //MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let delegate = LocationManager.shared.delegate {
            delegate.locationManager(didFailWithError: error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.denied:
            break
        case CLAuthorizationStatus.notDetermined:
            break
        case CLAuthorizationStatus.restricted:
            LocationManager.stopMonitoringLocation()
            break
        default:
            if LocationManager.startUpdatingLocationWhenAuthorized {
                LocationManager.startMonitoringLocation()
            }
            break
        }
        if let delegate = LocationManager.shared.delegate {
            delegate.locationManager(didChangeAuthorization: status)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
            if let delegate = LocationManager.shared.delegate {
                delegate.locationManager(didUpdateLocations: location)
            }
        }
    }
    
}
