//
//  Coach.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/17/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

//
//  Trainer.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/16/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import Foundation
import RealmSwift

class Coach: Object {
    
    @objc dynamic var id = -1
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var fullName = "Default name"
    @objc dynamic var category = "Default category"
    @objc dynamic var experience = 0
    @objc dynamic var phone = "Default phone"
    @objc dynamic var email = "Default email"
    @objc dynamic var address = "Default address"
    let schedule = List<ScheduleItem>()
    
    @objc dynamic static var lastId = 0
    static func getId() -> Int {
        print(lastId)
        lastId += 1
        return lastId
    }
}



