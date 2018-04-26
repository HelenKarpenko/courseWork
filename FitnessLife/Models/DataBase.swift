//
//  DataBase.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/23/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import Foundation
import RealmSwift

class DataBase {
    
    static var shared = DataBase()
    let realm = try! Realm()
    
    var lessonTemplates = [Int: Lesson]()
    var scheduleItems = [Int: ScheduleItem]()
    var OLDCoaches = [Int: Coach]()
    var clients = [Int: IClient]()
    
    ///////////////////////////////////
    var privateClients: Results<PrivateClient>!
    var coaches: Results<Coach>!
    ///////////////////////////////////
    
    private init(){
        coaches = realm.objects(Coach.self)
        setCurrCoacheId()
        privateClients = realm.objects(PrivateClient.self)
    }
    
    ///////////////////////////////////
    func addNewClient(_ client: IClient) throws {
//        client.id = Array(self.clients.keys).sorted(by: <).last
        clients[client.id] = client
        try realm.write {
            realm.add(client as! Object)
        }
    }
    
    func addNewCoach(_ coach: Coach) throws {
        try realm.write {
            realm.add(coach)
        }
    }

    func removeCoach(_ coach: Coach) throws {
        try realm.write {
            realm.delete(coach)
        }
    }
    
    /////////////////////////////////////
    
//    func getAllCoaches() {
//        let allCoaches = realm.objects(Coach.self)
//        for coach in allCoaches {
//            coaches[coach.id] = coach
//        }
//    }
    
    func getAllLessonTemplates(){
        let allLessons = realm.objects(Lesson.self)
        for lesson in allLessons {
            lessonTemplates[lesson.id] = lesson
        }
    }
    
    func setCurrLessonTemplateId(){
        let id = Array(self.lessonTemplates.keys).sorted(by: <).last
        Lesson.lastId = id!
    }
    
    func getAllScheduleItems() {
        let allScheduleItems = realm.objects(ScheduleItem.self)
        for item in allScheduleItems {
            scheduleItems[item.id] = item
        }
    }
    
    func setCurrScheduleItemId(){
        let id = Array(self.scheduleItems.keys).sorted(by: <).last
        ScheduleItem.lastId = id!
    }
    
    
    
    func setCurrCoacheId(){
        let id = Array(self.coaches).sorted(by: { $0.id < $1.id }).last?.id
        Coach.lastId = id!
    }
    
    // MARK: - Client
    
    func getAllPrivateClients() {
        privateClients = realm.objects(PrivateClient.self)
        for client in privateClients {
            clients[client.id] = client
        }
    }
    
//    func setCurrClientId(){
//        let id = Array(self.clients.keys).sorted(by: <).last
//        Client.lastId = id!
//    }
    
    func getAllCorporateClient() {
        let allClients = realm.objects(CorporateClient.self)
        for client in allClients {
            clients[client.id] = client
        }
    }
    
    func removeClient(_ client: IClient) {
        try! realm.write {
//            for lesson in client.schedule {
//
//                if(client is PrivateClient) {
//                    if let index = lesson.privateClients.index(where: { $0.id == client.id }) {
//                        lesson.privateClients.remove(at: index)
//                    }
//                } else {
//                    if let index = lesson.corporateClients.index(where: { $0.id == client.id }) {
//                        lesson.corporateClients.remove(at: index)
//                    }
//                }
//            }
            realm.delete(client as! Object)
        }
//        self.clients.removeValue(forKey: client.id)
//        removeObj(client as! Object)
    }
    
//    private func removeObj(_ object: Object){
//        try! realm.write {
//            realm.delete(object)
//        }
//    }
    
    //        let realm = try! Realm()
    //        let clients = realm.objects(Client.self)
    //        print(clients)
    ////        try! realm.write {
    ////            for coach in coaches {
    ////                coach.name = coach.name + "+"
    ////            }
    ////        }
    ////
    //        let c = realm.objects(Coach.self)
    //        print(c)
    
    
    //    func copy() -> Lesson {
    //        let id = self.id
    //        let title = self.title
    //        let category = self.category
    //        let maxPeopleCnt = self.maxPeopleCnt
    //        let duration = self.duration
    //
    //        let copy = Lesson();
    //        copy.id = id
    //        copy.title = title
    //        copy.category = category
    //        copy.maxPeopleCnt = maxPeopleCnt
    //        copy.duration = duration
    //        return copy
    //    }
    
    // MARK: - LessonTemplate
    
    //    func populateLessonTemplate() {
    //        let lesson1 = Lesson(1, "BASIC YOGA", "Yoga", 10, 60)
    //        let lesson2 = Lesson(2, "STRETCHIN", "Gymnastics", 10, 120)
    //        let lesson3 = Lesson(3, "AQUA STRONG", "Swimming", 10, 60)
    //
    //        self.lessonTemplate[lesson1.id] = lesson1
    //        self.lessonTemplate[lesson2.id] = lesson2
    //        self.lessonTemplate[lesson3.id] = lesson3
    //    }
    
    //    func getLessonTemplate(withId id: Int) -> Lesson? {
    //
    //        guard let lesson = self.lessonTemplate[id] else {
    //            print("❌ Cannot find lesson with id: \(id)")
    //            return nil
    //        }
    //
    //        return lesson.copy()
    //    }
    
    // MARK: - Start. Fill data base
    
    func start(){
        populateLessonTemplate()
        populateScheduleItem()
        populateClients()
        populateCoaches()
        
        OLDCoaches[1]?.schedule.append(scheduleItems[1]!)
        scheduleItems[1]?.coach = OLDCoaches[1]!
        OLDCoaches[2]?.schedule.append(scheduleItems[2]!)
        scheduleItems[2]?.coach = OLDCoaches[2]!
        OLDCoaches[3]?.schedule.append(scheduleItems[3]!)
        scheduleItems[3]?.coach = OLDCoaches[3]!
        
        clients[1]?.schedule.append(scheduleItems[1]!)
        scheduleItems[1]?.privateClients.append(clients[1]! as! PrivateClient)
        clients[1]?.schedule.append(scheduleItems[2]!)
        scheduleItems[2]?.privateClients.append(clients[1]! as! PrivateClient)
        clients[1]?.schedule.append(scheduleItems[3]!)
        scheduleItems[3]?.privateClients.append(clients[1]! as! PrivateClient)

        clients[2]?.schedule.append(scheduleItems[1]!)
        scheduleItems[1]?.privateClients.append(clients[2]! as! PrivateClient)
        clients[2]?.schedule.append(scheduleItems[2]!)
        scheduleItems[2]?.privateClients.append(clients[2]! as! PrivateClient)
        clients[2]?.schedule.append(scheduleItems[3]!)
        scheduleItems[3]?.privateClients.append(clients[2]! as! PrivateClient)

        clients[3]?.schedule.append(scheduleItems[1]!)
        scheduleItems[1]?.corporateClients.append(clients[3]! as! CorporateClient)
        clients[3]?.schedule.append(scheduleItems[2]!)
        scheduleItems[2]?.corporateClients.append(clients[3]! as! CorporateClient)
        clients[3]?.schedule.append(scheduleItems[3]!)
        scheduleItems[3]?.corporateClients.append(clients[3]! as! CorporateClient)
    }
    
    func populateLessonTemplate() {
        let lessonType1 = Lesson()
        lessonType1.id = Lesson.getId()
        lessonType1.title = "BASIC YOGA"
        lessonType1.category = "Yoga"
        lessonType1.maxPeopleCnt = 10
        lessonType1.duration = 60
        
        let lessonType2 = Lesson()
        lessonType2.id = Lesson.getId()
        lessonType2.title = "STRETCHIN"
        lessonType2.category = "Gymnastics"
        lessonType2.maxPeopleCnt = 10
        lessonType2.duration = 120
        
        let lessonType3 = Lesson()
        lessonType3.id = Lesson.getId()
        lessonType3.title = "AQUA STRONG"
        lessonType3.category = "Swimming"
        lessonType3.maxPeopleCnt = 20
        lessonType3.duration = 60
        
        self.lessonTemplates[lessonType1.id] = lessonType1
        self.lessonTemplates[lessonType2.id] = lessonType2
        self.lessonTemplates[lessonType3.id] = lessonType3
    }
    
    func populateScheduleItem() {
        let scheduleItem1 = ScheduleItem()
        scheduleItem1.id = ScheduleItem.getId()
        scheduleItem1.lesson = self.lessonTemplates[1]!
        scheduleItem1.date = dateFromString("2018/04/24 10:30:00")
        
        let scheduleItem2 = ScheduleItem()
        scheduleItem2.id = ScheduleItem.getId()
        scheduleItem2.lesson = self.lessonTemplates[2]!
        scheduleItem2.date = dateFromString("2018/04/25 10:30:00")
        
        let scheduleItem3 = ScheduleItem()
        scheduleItem3.id = ScheduleItem.getId()
        scheduleItem3.lesson = self.lessonTemplates[3]!
        scheduleItem3.date = dateFromString("2018/04/26 10:30:00")
        
        self.scheduleItems[scheduleItem1.id] = scheduleItem1
        self.scheduleItems[scheduleItem2.id] = scheduleItem2
        self.scheduleItems[scheduleItem3.id] = scheduleItem3
    }
    
    func populateCoaches() {
        let coach1 = Coach()
        coach1.id = Coach.getId()
        coach1.fullName = "Anna Chumak"
        coach1.category = "Yoga"
        coach1.experience = 3
        
        let coach2 = Coach()
        coach2.id = Coach.getId()
        coach2.fullName = "Vika Karpenko"
        coach2.category = "Gymnastics"
        coach2.experience = 5
        
        let coach3 = Coach()
        coach3.id = Coach.getId()
        coach3.fullName = "Ivan Krabs"
        coach3.category = "Swimming"
        coach3.experience = 15

        self.OLDCoaches[coach1.id] = coach1
        self.OLDCoaches[coach2.id] = coach2
        self.OLDCoaches[coach3.id] = coach3
    }

    func populateClients() {
        let privateClientCreator = PrivateClientCreator()
        let corporateClientCreator = CorporateClientCreator()
        
        let client1 = privateClientCreator.createClient(withFullName: "Elena Karpenko")
        let client2 = privateClientCreator.createClient(withFullName: "Alex Ivanov")
        let client3 = corporateClientCreator.createClient(withFullName: "Anna Flower")
        let client4 = corporateClientCreator.createClient(withFullName: "Julia Chubaka")

        self.clients[client1.id] = client1
        self.clients[client2.id] = client2
        self.clients[client3.id] = client3
        self.clients[client4.id] = client4
    }
}
