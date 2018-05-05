//
//  LocationManager.swift
//  Dryveways
//
//  Created by Apple on 09/08/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import CoreLocation
import CoreLocation

class LocationManager: NSObject , CLLocationManagerDelegate{
    
    fileprivate var locationManager: CLLocationManager = CLLocationManager()
    static let sharedInstance = LocationManager()
    var locationAuthorizationStatus:CLAuthorizationStatus = .denied
    fileprivate var locationStatus: String = ""
    
    fileprivate override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            //locationManager.requestAlwaysAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func startLocationServices(){
        //self.timer?.invalidate()
        self.locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdating(){
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        
        if let location = manager.location {
            
            
            print(location.coordinate)
            
            SharedPrefrence.sharedInstance.setCurrentLocation(location.coordinate.latitude, long: location.coordinate.longitude)
            /*NotificationsHandler.postNotification(AppNotificationsCase.didUpdateLocation, message: NotificationMessageWrapper(message: location))*/
        }
        /*self.timer?.invalidate()
        self.timer =  Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(LocationManager.startLocationServices), userInfo: nil, repeats: false)*/
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        
        print(error)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        var shouldIAllow = false
        //
        
        locationAuthorizationStatus = status
        
        switch locationAuthorizationStatus {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.notDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        //NotificationCenter.default.post(name: Notification.Name(rawValue: "LocationHasbeenUpdated"), object: nil)
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        } else {
            NSLog("Denied access:")
        }
    }
    

}
