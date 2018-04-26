//
//  Lesson.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/17/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit
import RealmSwift

class Lesson: Object {
      
    @objc dynamic var id = -1
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var title = "Default title"
    @objc dynamic var category = "Default category"
    @objc dynamic var maxPeopleCnt = 0
    @objc dynamic var duration = 0
    
    @objc dynamic static var lastId = 0
    static func getId() -> Int {
        lastId += 1
        return lastId
    }
}
