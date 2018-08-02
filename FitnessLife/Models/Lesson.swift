//
//  Lesson.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/17/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit
import RealmSwift

enum SportCategory: String {
    case swimming = "Swimming"
    case box = "Box"
    case gymnastics = "Gymnastics"
    case yoga = "Yoga"
    case dance = "Dance"
}

class Lesson: Object {
      
    @objc dynamic var id = -1
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var title = "Default title"
    @objc dynamic var category: String = SportCategory.swimming.rawValue
    var icon: UIImage {
        switch SportCategory(rawValue: category)! {
        case SportCategory.swimming:
            return #imageLiteral(resourceName: "swimming")
        case SportCategory.box:
            return #imageLiteral(resourceName: "boxing")
        case SportCategory.dance:
            return #imageLiteral(resourceName: "dancing")
        case SportCategory.gymnastics:
            return #imageLiteral(resourceName: "gymnastics")
        case SportCategory.yoga:
            return #imageLiteral(resourceName: "yoga")
        }
    }
    @objc dynamic var maxPeopleCnt = 0
    @objc dynamic var duration = 0
    @objc dynamic var price = 0
    
    @objc dynamic static var lastId = 0
    static func getId() -> Int {
        lastId += 1
        return lastId
    }
}
