//
//  ScheduleItem.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/21/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import Foundation
import RealmSwift

class ScheduleItem: Object {
    
    @objc dynamic var id = -1
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var lesson: Lesson?
    @objc dynamic var coach: Coach?
    @objc dynamic var date = Date()
    var corporateClients = List<CorporateClient>()
    var privateClients = List<PrivateClient>()
    
    @objc dynamic static var lastId = 0
    static func getId() -> Int {
        lastId += 1
        return lastId
    }
}
