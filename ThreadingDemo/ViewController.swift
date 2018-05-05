//
//  ViewController.swift
//  ThreadingDemo
//
//  Created by Honey Maheshwari on 20/01/18.
//  Copyright © 2018 Honey Maheshwari. All rights reserved.
//

import UIKit

class ViewController: UIViewController, OperationManagerDelegate, DataManagerDelegate {
    
    var timer: Timer!
    var operationManager: OperationManager!
    var count: Int = 0
    var dataManager: DataManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dataManager = DataManager()
        dataManager.delegate = self
        
        operationManager = OperationManager(identifiers: [OperationIdentifiers.first, OperationIdentifiers.second, OperationIdentifiers.third], delegate: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button Actions
    
    @IBAction func startButtonTapped(_ sender: Any) {
        if let timer = self.timer {
            timer.invalidate()
        }
        self.count = 1
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.timerFunction()
        })
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        operationManager.cancelAllOperations()
        dataManager.resetItems()
        if let timer = self.timer {
            timer.invalidate()
        }
    }
    
    func timerFunction() {
        operationManager.startOperation(withIdentifire: OperationIdentifiers.first)
        if count % 2 == 0 {
            operationManager.startOperation(withIdentifire: OperationIdentifiers.second)
        }
        count += 1
    }
    
    //MARK: OperationManagerDelegate
    
    func performOperation(identifire: String) {
        if identifire == OperationIdentifiers.first {
            dataManager.appendLoaction(coordinate: LocationManager.currentCoordinate)
        } else if identifire == OperationIdentifiers.second {
            dataManager.appendBatteryLevel(level: BatteryManager.batteryPercentage)
        } else if identifire == OperationIdentifiers.third {
            self.prepareParametersAndCallWebservice(items: dataManager.items)
        }
    }
    
    //MARK: DataManagerDelegate
    
    func performThirdThread() {
        operationManager.startOperation(withIdentifire: OperationIdentifiers.third)
    }
    
    //MARK: API
    
    func prepareParametersAndCallWebservice(items: [ListItemModel]) {
        dataManager.resetItems()
        var str = ""
        for item in items {
            str += str.characters.count == 0 ? item.description : "; \(item.description)"
        }
        callWebservice(param: str)
    }
    
    func callWebservice(param: String) {
        print("param >>> \(param)")
    }
    
}

