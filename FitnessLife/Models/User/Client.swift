//
//  Client.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/22/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit
import RealmSwift


enum ClientType {
    case client
    case coach
    case admin
}

final class Client: Object, IUser {
    @objc dynamic var id = -1
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var fullName = "Client"
    @objc dynamic var createDate = Date()
    @objc dynamic var phone = "Default client phone"
    @objc dynamic var email = "Default client email"
    @objc dynamic var address = "Default client address"
    @objc dynamic var password = "1234"
    var schedule = List<ScheduleItem>()

    @objc dynamic static var lastId = 0
    static func getId() -> Int {
        lastId += 1
        return lastId
    }

    static var successor: IUser.Type? = Coach.self
    
    func getPayment() -> Int {
        var payment = 0
        for item in schedule {
            payment += item.lesson!.price
        }
        return payment
    }
    
    func lessonExists(_ lesson: ScheduleItem) -> Bool {
        return self.schedule.contains(lesson)
    }
    
    static func find(byEmail email: String, password: String) -> IUser? {
        var user = DataBase.shared.getClient(byEmail: email, andPassword: password)
        if user == nil {
            if let successor = successor {
                user = successor.find(byEmail: email, password: password)
            }
        }
        return user
    }
}

