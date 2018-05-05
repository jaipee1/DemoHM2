//
//  OperationManager.swift
//  ThreadingDemo
//
//  Created by Honey Maheshwari on 20/01/18.
//  Copyright © 2018 Honey Maheshwari. All rights reserved.
//

import Foundation

protocol OperationManagerDelegate {
    func performOperation(identifire: String)
}

class OperationManager {
    var operations: [ListOperation] = []
    var delegate: OperationManagerDelegate?
    
    init() {
        
    }
    
    init(identifiers: [String], delegate: OperationManagerDelegate? = nil) {
        self.delegate = delegate
        for identifier in identifiers {
            let operation = ListOperation(identifier: identifier, completionBlock: {
                if let delegate = self.delegate {
                    delegate.performOperation(identifire: identifier)
                }
            })
            operations.append(operation)
        }
    }
    
    func appendOperation(withIdentifire identifier: String) {
        let filteredOperation = operations.filter() { $0.identifier == identifier }
        if filteredOperation.count == 0 {
            let operation = ListOperation(identifier: identifier, completionBlock: {
                if let delegate = self.delegate {
                    delegate.performOperation(identifire: identifier)
                }
            })
            operations.append(operation)
        }
    }
    
    func startOperation(withIdentifire identifire: String)  {
        let filteredOperation = operations.filter() { $0.identifier == identifire }
        if let operation = filteredOperation.first {
            operation.start()
        }
    }
    
    func cancelOperation(withIdentifire identifire: String) {
        let filteredOperation = operations.filter() { $0.identifier == identifire }
        if let operation = filteredOperation.first {
            operation.cancel()
        }
    }
    
    func cancelAllOperations() {
        for operation in operations {
            operation.cancel()
        }
    }
}


class ListOperation {
    
    var queue: DispatchQueue!
    var workItem: DispatchWorkItem!
    var identifier: String!
    
    init(identifier: String, completionBlock: @escaping CompletionBlock) {
        self.identifier = identifier
        self.queue = DispatchQueue(label: identifier, attributes: .concurrent)
        self.workItem = DispatchWorkItem {
            completionBlock()
        }
    }
    
    func start() {
        self.queue.async(execute: workItem)
    }
    
    func cancel() {
        self.workItem.cancel()
    }
    
}
