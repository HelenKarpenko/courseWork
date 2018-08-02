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

enum ScheduleError: Error {
    case categoryDoesNotMatch
    case dateIsBusy
    
    var localizedDescription: String {
        switch self {
        case .categoryDoesNotMatch:
            return NSLocalizedString("Sorry, but lesson category does not match with the coach category.", comment: "My error")
        case .dateIsBusy:
            return NSLocalizedString("Sorry, but this date is already in the schedule.", comment: "My error")
        }
    }
}

enum Rank: Int {
    case senior
    case middle
    case junior
}

protocol IRank {
    var name: String {get set}
    var icon: UIImage {get set}
    var rate: Int {get set}
}

final class Senior: IRank {
    var name = "Senior"
    var icon = #imageLiteral(resourceName: "senior")
    var rate = 3
}

final class Middle: IRank {
    var name = "Middle"
    var icon = #imageLiteral(resourceName: "middle")
    var rate = 2
}

final class Junior: IRank {
    var name = "Junior"
    var icon = #imageLiteral(resourceName: "junior")
    var rate = 1
}

protocol ICoach: IUser {
    var category: String {get set}
    var experience: Int {get set}
    var rankType: Int {get set}
    var rank: IRank {get}
    
    func addNewScheduleItem(_ item: ScheduleItem) throws
}

class Coach: Object, ICoach, IUser {
    @objc dynamic var id = -1
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var fullName = "Default coach name"
    @objc dynamic var category = "Default coach category"
    @objc dynamic var experience = 0
    @objc dynamic var rankType: Int = Rank.junior.rawValue
    @objc dynamic var phone = "Default coach phone"
    @objc dynamic var email = "Default coach email"
    @objc dynamic var address = "Default coach address"
    @objc dynamic var password = "1234"
    var schedule = List<ScheduleItem>()
    var rank: IRank {
        switch Rank(rawValue:rankType)! {
        case .junior:
            return Junior()
        case .middle:
            return Middle()
        case .senior:
            return Senior()
        }
    }
    
    @objc dynamic static var lastId = 0
    static func getId() -> Int {
        print(lastId)
        lastId += 1
        return lastId
    }
    
    static var successor: IUser.Type?
    
    func getPayment() -> Int {
        var payment = 0
        for item in schedule {
            payment += item.lesson!.maxPeopleCnt * item.lesson!.price
        }
        payment = payment * self.rank.rate
        return payment
    }
    
    func levelUp() {
        
        switch rank {
        case is Junior:
            rankType = Rank.middle.rawValue
        case is Middle:
            rankType = Rank.senior.rawValue
        case is Senior:
            rankType = Rank.senior.rawValue
        default: break
        }
    }
    
    func levelDown() {
        switch rank {
        case is Senior:
            rankType = Rank.middle.rawValue
        case is Middle:
            rankType = Rank.junior.rawValue
        case is Junior:
            rankType = Rank.junior.rawValue
        default: break
        }
    }
    
    static func find(byEmail email: String, password: String) -> IUser? {
        let user = DataBase.shared.getCoach(byEmail: email, andPassword: password)
        return user
    }
    
    func addNewScheduleItem(_ item: ScheduleItem) throws {
        self.schedule.append(item)
    }
}

class ProxyCoach: ICoach {
    
    private var coach: ICoach
    
    var category: String {
        get {
            return coach.category
        }
        set(value){
            coach.category = value
        }
    }
    
    var experience: Int {
        get {
            return coach.experience
        }
        set(value){
            coach.experience = value
        }
    }
    
    var rankType: Int {
        get {
            return coach.rankType
        }
        set(value){
            coach.rankType = value
        }
    }
    
    var rank: IRank {
        get {
            return coach.rank
        }
    }
    
    var id: Int {
        get {
            return coach.id
        }
        set(value){
            coach.id = value
        }
    }
    
    var fullName: String {
        get {
            return coach.fullName
        }
        set(value){
            coach.fullName = value
        }
    }
    
    var phone: String {
        get {
            return coach.phone
        }
        set(value){
            coach.phone = value
        }
    }
    
    var email: String {
        get {
            return coach.email
        }
        set(value){
            coach.email = value
        }
    }
    
    var address: String {
        get {
            return coach.address
        }
        set(value){
            coach.address = value
        }
    }
    
    var password: String {
        get {
            return coach.password
        }
        set(value){
            coach.password = value
        }
    }
    
    var schedule: List<ScheduleItem> {
        get {
            return coach.schedule
        }
        set(value){
            coach.schedule = value
        }
    }
    
    static var lastId: Int {
        get {
            return Coach.lastId
        }
        set(value){
            Coach.lastId = value
        }
    }
    
    static var successor: IUser.Type? {
        get {
            return Coach.successor
        }
        set(value){
            Coach.successor = value
        }
    }
    
    init(_ coach: ICoach){
        self.coach = coach
    }
    
    func getPayment() -> Int {
        return self.coach.getPayment()
    }
    
    static func primaryKey() -> String? {
        return Coach.primaryKey()
    }
    
    static func getId() -> Int {
        return Coach.getId()
    }
    
    static func find(byEmail email: String, password: String) -> IUser? {
        return Coach.find(byEmail: email, password: password)
    }
    
    func addNewScheduleItem(_ item: ScheduleItem) throws {
        if self.category != item.lesson?.category {
            throw ScheduleError.categoryDoesNotMatch
        }
        
        for lesson in self.schedule {
            if lesson.date == item.date {
                throw ScheduleError.dateIsBusy
            }
        }
        
        try self.coach.addNewScheduleItem(item)
    }
    
}

