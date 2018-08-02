//
//  StateManager.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/30/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

typealias State = [String: Any]

private enum StateKeys: String {
    case mainTabIndex
    case currentScreen
    
}

class StateManager {
    
    // PATTERN: singleton
    static let shared = StateManager(storage: UserDefaults.standard)
    
    
    // PATTERN: dependency injection
    private var storage: StateStorage
    fileprivate init(storage: StateStorage) {
        self.storage = storage
    }
    
    
    // PATTERN: memento
    var state: State? {
        get {
            let result = storage.getState(forKey: StateKeys.currentScreen.rawValue)
            return result
        }
        set {
            storage.setState(newValue, forKey: StateKeys.currentScreen.rawValue)
        }
    }
    
    var mainTabIndex: Int {
        get {
            // if not found returns 0 which will correspond to first tab
            return storage.integer(forKey: StateKeys.mainTabIndex.rawValue)
        }
        set {
            storage.set(newValue, forKey: StateKeys.mainTabIndex.rawValue)
        }
    }
    
    func store(viewController: Restorable) {
        let key = String(describing: type(of: viewController))
        var state: State = self.state ?? State()
        state += [key: viewController.state]
        self.state = state
        print("Stored state for \(key)")
    }
    
    func restore(viewController: Restorable) {
        let key = String(describing: type(of: viewController))
        if let state = self.state?[key] as? State {
            _ = viewController.restore(from: state)
            print("Re-Stored state for \(key)")
        }
    }
    
}

func += (lhs: inout State, rhs: State) {
    lhs.merge(rhs, uniquingKeysWith: { $1 })
}
