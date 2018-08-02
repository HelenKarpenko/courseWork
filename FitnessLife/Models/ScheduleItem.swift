//
//  ScheduleItem.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/21/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import Foundation
import RealmSwift

enum ClientError: Error {
    case groupIsFull
    case alreadyExists
    case notExists
    
    var localizedDescription: String {
        switch self {
        case .groupIsFull:
            return NSLocalizedString("Sorry, but this group is full.", comment: "My error")
        case .alreadyExists:
            return NSLocalizedString("Client is already enrolled in this lesson", comment: "My error")
        case .notExists:
            return NSLocalizedString("Client was not enrolled in this lesson", comment: "My error")
        }
    }
}

enum WeekDay: Int {
    case all = 0
    case monday = 2
    case tuesday
    case wednesday
    case thursday
    case friday
}


enum GroupState: Int {
    case full
    case notFull
}

protocol IGroupState {
    var name: String {get set}
    var icon: UIImage {get set}
    
    var canAddClient: Bool {get}
}

final class FullGroup: IGroupState {
    var name = "Full group"
    var icon = #imageLiteral(resourceName: "full")
    var canAddClient = false
}

final class NotFullGroup: IGroupState {
    var name = "Not full group"
    var icon = #imageLiteral(resourceName: "notFull")
    var canAddClient = true
}

class ScheduleItem: Object {
    
    @objc dynamic var id = -1
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var lesson: Lesson?
    @objc dynamic var coach: Coach?
    @objc dynamic var date = Date()
    @objc dynamic var groupStateType: Int = GroupState.notFull.rawValue
    var groupState: IGroupState {
        switch GroupState(rawValue: groupStateType)! {
        case .full:
            return FullGroup()
        case .notFull:
            return NotFullGroup()
        }
    }
    @objc dynamic var day = 1
    
    var clients = List<Client>()
    
    @objc dynamic static var lastId = 0
    static func getId() -> Int {
        lastId += 1
        return lastId
    }
    
    func copy() -> ScheduleItem {
        let id = ScheduleItem.getId()
        let lesson = self.lesson
        let coach = self.coach
        let date = self.date
        
        let copy = ScheduleItem();
        copy.id = id
        copy.lesson = lesson
        copy.coach = coach
        copy.date = date
        return copy
    }
    
    func setWeekDay(){
        self.day = dayOfWeekFromDate(self.date)
    }
    
    func groupIsFull() -> Bool {
        return ((self.lesson?.maxPeopleCnt)! - self.clients.count) == 0
    }
    
    func addClient(_ client: Client) throws {
        if !self.groupState.canAddClient {
            throw ClientError.groupIsFull
        }
        
        if self.clients.contains(client) {
            throw ClientError.alreadyExists
        }
        
        self.clients.append(client)
        client.schedule.append(self)
        
        if self.clients.count == self.lesson?.maxPeopleCnt {
            self.groupStateType = GroupState.full.rawValue
        }
    }

    func removeClient(_ client: Client) throws {
        
        if !self.clients.contains(client) {
            throw ClientError.notExists
        }
        
        self.clients.remove(at: self.clients.index(of: client)!)
        client.schedule.remove(at: client.schedule.index(of: self)!)
        
        if self.clients.count < (self.lesson?.maxPeopleCnt)! {
            self.groupStateType = GroupState.notFull.rawValue
        }
    }
}
