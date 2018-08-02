//
//  StateStorage.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/30/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

// PATTERN Strategy (for defining different type of storage. Concrete implementation can be standard iOS UserDefaults or something another)
protocol StateStorage {
    // Get
    func integer(forKey defaultName: String) -> Int
    func object(forKey defaultName: String) -> Any?
    
    // Set
    func set(_ value: Any?, forKey defaultName: String)
    
    // Delete
    func removeObject(forKey defaultName: String)
    
    // Sync
    @discardableResult
    func synchronize() -> Bool
    
    // Custom methods with default implementation in extension below
    func getState(forKey key: String) -> State?
    func setState(_ state: State?, forKey key: String)
}

extension StateStorage {
    func getState(forKey key: String) -> State? {
        guard let data = object(forKey: key) as? Data else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? State
    }
    
    public func setState(_ state: State?, forKey key: String) {
        guard let state = state else {
            removeObject(forKey: key)
            return
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: state)
        set(data, forKey: key)
        synchronize()
    }
}

// bind protocol to our UserDefaults (FOR TESTING purposes)
extension UserDefaults: StateStorage {}
