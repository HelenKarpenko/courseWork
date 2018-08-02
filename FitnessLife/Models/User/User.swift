//
//  User.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/30/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit
import RealmSwift

protocol IUser {
    var id: Int {get set}
    static func primaryKey() -> String?
    var fullName: String {get set}
    var phone: String {get set}
    var email: String {get set}
    var address: String {get set}
    var password: String {get set}
    var schedule: List<ScheduleItem> {get set}
    
    static var lastId: Int {get set}
    static func getId() -> Int
    
    static var successor: IUser.Type? { get set }
    
    func getPayment() -> Int
    static func find(byEmail email: String, password: String) -> IUser?
}

class User{
    
    var user: IUser
    
    static var currUser: IUser? = nil
    
    var id: Int {
        get {
            return user.id
        }
        set(value){
            user.id = value
        }
    }
    
    var fullName: String {
        get{
            return user.fullName
        }
        set(value){
            user.fullName = value
        }
    }
    
    var phone: String {
        get{
            return user.phone
        }
        set(value){
            user.phone = value
        }
    }
    
    var email: String {
        get{
            return user.email
        }
        set(value){
            user.email = value
        }
    }
    
    var address: String {
        get{
            return user.address
        }
        set(value){
            user.address = value
        }
    }
    
    var password: String {
        get{
            return user.password
        }
        set(value){
            user.password = value
        }
    }
    
    var schedule: List<ScheduleItem> {
        get{
            return user.schedule
        }
        set(value){
            user.schedule = value
        }
    }
    
    init(_ user: IUser){
        self.user = user
    }
    
    func getPayment() -> Int {
        return self.user.getPayment()
    }
    
}


