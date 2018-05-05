//
//  BatteryManager.swift
//  ThreadingDemo
//
//  Created by Honey Maheshwari on 20/01/18.
//  Copyright © 2018 Honey Maheshwari. All rights reserved.
//

import UIKit

class BatteryManager: NSObject {
    
    static let shared = BatteryManager()
    
    class var batteryLevel: Float {
        get {
            return UIDevice.current.batteryLevel
        }
    }
    
    class var batteryState: UIDeviceBatteryState {
        get {
            return UIDevice.current.batteryState
        }
    }
    
    class var batteryPercentage: Float {
        get {
            return batteryLevel * 100
        }
    }
    
    override init() {
        super.init()
        self.startBatteryMonitoring()
    }
    
    deinit {
        UIDevice.current.isBatteryMonitoringEnabled = false
    }
    
    func startBatteryMonitoring() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        /*
         NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: NSNotification.Name.UIDeviceBatteryStateDidChange, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: NSNotification.Name.UIDeviceBatteryLevelDidChange, object: nil)
         */
    }
    
}
