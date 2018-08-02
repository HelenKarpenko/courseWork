//
//  Restorable.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/30/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

protocol Restorable {
    var state: State { get }
    func restore(from state: State) -> Bool
}

