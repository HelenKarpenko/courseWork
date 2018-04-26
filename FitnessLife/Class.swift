//
//  Class.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/17/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

class Class: NSObject, Equatable {
    var title: String
    var date: NSDate
    var category: Category
    var coach: Coach
    var maxPeopleCnt: Int
    var people = [People]()
    
    init(_ category: Category,
         _ title: String,
         _ date: NSDate,
         _ coach: Coach,
         _ maxPeopleCnt: Int) {
        self.title = title
        self.date = date
        self.category = category
        self.coach = coach
        self.maxPeopleCnt = maxPeopleCnt
    }
    
    func setCoach(_ coach: Coach) -> Bool{
        guard coach.addOccupation(self) else {
            return false
        }
        self.coach = coach
        return true
    }
    
    // Equatable implementation
    static func == (lhs: Class, rhs: Class) -> Bool {
        return lhs.title == rhs.title &&
            lhs.date == rhs.date &&
            lhs.category == rhs.category
    }
}
