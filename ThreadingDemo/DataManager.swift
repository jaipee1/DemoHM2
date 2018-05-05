//
//  DataManager.swift
//  ThreadingDemo
//
//  Created by Honey Maheshwari on 20/01/18.
//  Copyright © 2018 Honey Maheshwari. All rights reserved.
//

import UIKit
import CoreLocation

protocol DataManagerDelegate {
    func performThirdThread()
}

class DataManager: NSObject {
    
    var delegate: DataManagerDelegate?
    var items: [ListItemModel] = [] {
        willSet {
            if let item = newValue.last, item.batteryLevel != nil, newValue.count == 3 {
                if let delegate = self.delegate {
                    delegate.performThirdThread()
                }
            }
        }
    }
    
    func resetItems() {
        items.removeAll()
    }
    
    func appendLoaction(coordinate: CLLocationCoordinate2D) {
        if items.count == 0 {
            items.append(ListItemModel(userLocations: [coordinate], batteryLevel: nil))
        } else {
            if let item = items.last, item.batteryLevel != nil {
                items.append(ListItemModel(userLocations: [coordinate], batteryLevel: nil))
            } else if var item = items.last {
                item.userLocations.append(coordinate)
                items[items.count - 1] = item
            }
        }
    }
    
    func appendBatteryLevel(level: Float) {
        if var item = items.last {
            item.batteryLevel = level
            items[items.count - 1] = item
        }
    }
    
}

struct ListItemModel {
    var userLocations: [CLLocationCoordinate2D]!
    var batteryLevel: Float?
    
    var description: String {
        get {
            var str = ""
            if let userLocations = userLocations {
                for location in userLocations {
                    str += str.characters.count == 0 ? "c: \(location.stringValue)" : ",c: \(location.stringValue)"
                }
            }
            if let per = batteryLevel {
                str += String(format: "b: %0.0f", per)
            }
            return str
        }
    }
    
}
