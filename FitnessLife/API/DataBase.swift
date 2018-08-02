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
    lazy var realm = try! Realm()
    
    var lessonForPopulate = [Int: Lesson]()
    var scheduleItemsForPopulate = [Int: ScheduleItem]()
    var coachesForPopulate = [Int: Coach]()
    var clientsForPopulate = [Int: Client]()
    
    var clients: Results<Client>!
    var coaches: Results<Coach>!
    var schedule: Results<ScheduleItem>!
    var lessons: Results<Lesson>!
    
    private init(){
        let _ = Bundle.main.path(forResource: "default", ofType: "realm")
        let destPath = Realm.Configuration.defaultConfiguration.fileURL?.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destPath!) {
            print("File Exists")
        } else {
            print("File NOT Exists")
            populateDB()
            do {
                try populateCoaches()
                try populateClients()
                try populateLessons()
                try populateSchedule()
            } catch {
                fatalError(error.localizedDescription)
            }
            
        }
        schedule = realm.objects(ScheduleItem.self)
        setCurrScheduleItemId()
        coaches = realm.objects(Coach.self)
        setCurrCoacheId()
        lessons = realm.objects(Lesson.self)
        setCurrLessonId()
        clients = realm.objects(Client.self)
        setCurrClientId()
    }
    
    ///////////////////////////////////

    // MARK: - Add
    
    func addNewClient(_ client: Client) throws {
        try realm.write {
            realm.add(client)
        }
    }
    
    func addNewCoach(_ coach: Coach) throws {
        try realm.write {
            realm.add(coach)
        }
    }

    func addNewScheduleItem(_ item: ScheduleItem) throws {
        try realm.write {
            realm.add(item)
        }
    }
    
    // MARK: - Remove
    
    func removeClient(_ client: Client) throws {
        try realm.write {
            realm.delete(client)
        }
    }
    
    func removeCoach(_ coach: Coach) throws {
        try realm.write {
            realm.delete(coach)
        }
    }
    
    func removeScheduleItem(_ item: ScheduleItem) throws {
        try realm.write {
            realm.delete(item)
        }
    }
    
    // MARK: - SetCurrId
    
    func setCurrCoacheId(){
        let id = Array(self.coaches).sorted(by: { $0.id < $1.id }).last?.id
        Coach.lastId = id!
    }
    
    func setCurrScheduleItemId(){
        let id = Array(self.schedule).sorted(by: { $0.id < $1.id }).last?.id
        ScheduleItem.lastId = id!
    }
    
    func setCurrLessonId(){
        let id = Array(self.lessons).sorted(by: { $0.id < $1.id }).last?.id
        Lesson.lastId = id!
    }
    
    func setCurrClientId(){
        let id = Array(self.clients).sorted(by: { $0.id < $1.id }).last?.id
        Client.lastId = id!
    }
    
    // MARK: - ScheduleItem. Add/Remove client
    
    func addClientToGroup(schedule: ScheduleItem, client: Client) throws {
        try realm.write {
            try schedule.addClient(client)
        }
    }
    
    func removeClientFromGroup(schedule: ScheduleItem, client: Client) throws {
        try realm.write {
            try schedule.removeClient(client)
        }
    }
    
    // MARK: - ScheduleItemTemplate
    
    func getScheduleItemTemplate(withId id: Int) -> ScheduleItem? {
        
        guard let item = self.schedule?[id] else {
            print("❌ Cannot find item with id: \(id)")
            return nil
        }
        
        return item.copy()
    }
    
    // MARK: - LogIn
    
    func emailIsExists(_ email: String) -> Bool {
        let result = realm.objects(Client.self).filter("email == %@", email).first
        return result != nil
    }
    
    func getClient(byEmail email: String, andPassword password: String) -> IUser? {
        let result = realm.objects(Client.self).filter("email == %@ AND password == %@", email, password).first
        return result
    }
    
    func getCoach(byEmail email: String, andPassword password: String) -> IUser? {
        let result = realm.objects(Coach.self).filter("email == %@ AND password == %@", email, password).first
        return result
    }
    

    // MARK: - Start. Populate data base
    
    func populateClients() throws {
        try realm.write {
            for client in clientsForPopulate.values {
                realm.add(client)
            }
        }
    }
    
    func populateCoaches() throws {
        try realm.write {
            for coach in coachesForPopulate.values {
                realm.add(coach)
            }
        }
    }
    
    func populateLessons() throws {
        try realm.write {
            for lesson in lessonForPopulate.values {
                realm.add(lesson)
            }
        }
    }
    
    func populateSchedule() throws {
        try realm.write {
            for scheduleItem in scheduleItemsForPopulate.values {
                realm.add(scheduleItem)
            }
        }
    }
    
    func populateDB(){
        populateLessonForDB()
        populateScheduleForDB()
        populateClientsForDB()
        populateCoachesForDB()
        
        coachesForPopulate[1]?.schedule.append(scheduleItemsForPopulate[1]!)
        scheduleItemsForPopulate[1]?.coach = coachesForPopulate[1]!
        coachesForPopulate[2]?.schedule.append(scheduleItemsForPopulate[2]!)
        scheduleItemsForPopulate[2]?.coach = coachesForPopulate[2]!
        coachesForPopulate[3]?.schedule.append(scheduleItemsForPopulate[3]!)
        scheduleItemsForPopulate[3]?.coach = coachesForPopulate[3]!
        
        clientsForPopulate[1]?.schedule.append(scheduleItemsForPopulate[1]!)
        scheduleItemsForPopulate[1]?.clients.append(clientsForPopulate[1]!)
        clientsForPopulate[1]?.schedule.append(scheduleItemsForPopulate[2]!)
        scheduleItemsForPopulate[2]?.clients.append(clientsForPopulate[1]!)
        clientsForPopulate[1]?.schedule.append(scheduleItemsForPopulate[3]!)
        scheduleItemsForPopulate[3]?.clients.append(clientsForPopulate[1]!)

        clientsForPopulate[2]?.schedule.append(scheduleItemsForPopulate[1]!)
        scheduleItemsForPopulate[1]?.clients.append(clientsForPopulate[2]!)
        clientsForPopulate[2]?.schedule.append(scheduleItemsForPopulate[2]!)
        scheduleItemsForPopulate[2]?.clients.append(clientsForPopulate[2]!)
        clientsForPopulate[2]?.schedule.append(scheduleItemsForPopulate[3]!)
        scheduleItemsForPopulate[3]?.clients.append(clientsForPopulate[2]!)

        clientsForPopulate[3]?.schedule.append(scheduleItemsForPopulate[1]!)
        scheduleItemsForPopulate[1]?.clients.append(clientsForPopulate[3]!)
        clientsForPopulate[3]?.schedule.append(scheduleItemsForPopulate[2]!)
        scheduleItemsForPopulate[2]?.clients.append(clientsForPopulate[3]!)
        clientsForPopulate[3]?.schedule.append(scheduleItemsForPopulate[3]!)
        scheduleItemsForPopulate[3]?.clients.append(clientsForPopulate[3]!)
    }
    
    func populateLessonForDB() {
        let lessonType1 = Lesson()
        lessonType1.id = Lesson.getId()
        lessonType1.title = "BASIC YOGA"
        lessonType1.category = "Yoga"
        lessonType1.maxPeopleCnt = 1
        lessonType1.duration = 60
        lessonType1.price = 100
        
        let lessonType2 = Lesson()
        lessonType2.id = Lesson.getId()
        lessonType2.title = "STRETCHIN"
        lessonType2.category = "Gymnastics"
        lessonType2.maxPeopleCnt = 10
        lessonType2.duration = 120
        lessonType2.price = 100
        
        let lessonType3 = Lesson()
        lessonType3.id = Lesson.getId()
        lessonType3.title = "AQUA STRONG"
        lessonType3.category = "Swimming"
        lessonType3.maxPeopleCnt = 20
        lessonType3.duration = 60
        lessonType3.price = 200
        
        let lessonType4 = Lesson()
        lessonType4.id = Lesson.getId()
        lessonType4.title = "HIP HOP"
        lessonType4.category = "Dance"
        lessonType4.maxPeopleCnt = 10
        lessonType4.duration = 60
        lessonType4.price = 150
        
        let lessonType5 = Lesson()
        lessonType5.id = Lesson.getId()
        lessonType5.title = "ONE PUNCH MAN"
        lessonType5.category = "Box"
        lessonType5.maxPeopleCnt = 5
        lessonType5.duration = 120
        lessonType5.price = 180
        
        let lessonType6 = Lesson()
        lessonType6.id = Lesson.getId()
        lessonType6.title = "YOGA"
        lessonType6.category = "Yoga"
        lessonType6.maxPeopleCnt = 5
        lessonType6.duration = 120
        lessonType6.price = 200
        
        let lessonType7 = Lesson()
        lessonType7.id = Lesson.getId()
        lessonType7.title = "BASIC GYMNASTICS"
        lessonType7.category = "Gymnastics"
        lessonType7.maxPeopleCnt = 5
        lessonType7.duration = 60
        lessonType7.price = 250
        
        let lessonType8 = Lesson()
        lessonType8.id = Lesson.getId()
        lessonType8.title = "AQUA MIX"
        lessonType8.category = "Swimming"
        lessonType8.maxPeopleCnt = 15
        lessonType8.duration = 120
        lessonType8.price = 150
        
        let lessonType9 = Lesson()
        lessonType9.id = Lesson.getId()
        lessonType9.title = "LATIN"
        lessonType9.category = "Dance"
        lessonType9.maxPeopleCnt = 8
        lessonType9.duration = 120
        lessonType9.price = 80
        
        let lessonType10 = Lesson()
        lessonType10.id = Lesson.getId()
        lessonType10.title = "BOX"
        lessonType10.category = "Box"
        lessonType10.maxPeopleCnt = 5
        lessonType10.duration = 120
        lessonType10.price = 140
        
        self.lessonForPopulate[lessonType1.id] = lessonType1
        self.lessonForPopulate[lessonType2.id] = lessonType2
        self.lessonForPopulate[lessonType3.id] = lessonType3
        self.lessonForPopulate[lessonType4.id] = lessonType4
        self.lessonForPopulate[lessonType5.id] = lessonType5
        self.lessonForPopulate[lessonType6.id] = lessonType6
        self.lessonForPopulate[lessonType7.id] = lessonType7
        self.lessonForPopulate[lessonType8.id] = lessonType8
        self.lessonForPopulate[lessonType9.id] = lessonType9
        self.lessonForPopulate[lessonType10.id] = lessonType10
    }
    
    func populateScheduleForDB() {
        let scheduleItem1 = ScheduleItem()
        scheduleItem1.id = ScheduleItem.getId()
        scheduleItem1.lesson = self.lessonForPopulate[1]!
        scheduleItem1.date = dateFromString("2018/04/24 10:30:00")
        
        let scheduleItem2 = ScheduleItem()
        scheduleItem2.id = ScheduleItem.getId()
        scheduleItem2.lesson = self.lessonForPopulate[2]!
        scheduleItem2.date = dateFromString("2018/04/25 10:30:00")
        
        let scheduleItem3 = ScheduleItem()
        scheduleItem3.id = ScheduleItem.getId()
        scheduleItem3.lesson = self.lessonForPopulate[3]!
        scheduleItem3.date = dateFromString("2018/04/26 10:30:00")
        
        self.scheduleItemsForPopulate[scheduleItem1.id] = scheduleItem1
        self.scheduleItemsForPopulate[scheduleItem2.id] = scheduleItem2
        self.scheduleItemsForPopulate[scheduleItem3.id] = scheduleItem3
    }
    
    func populateCoachesForDB() {
        
        // Yoga
        let coach1 = Coach()
        coach1.id = Coach.getId()
        coach1.fullName = "Anna Chumak"
        coach1.category = "Yoga"
        coach1.experience = 3
        coach1.rankType = 0
        coach1.phone = "+380 (99) 978 02 76"
        coach1.email = "coach@gmail.com"
        
        let coach2 = Coach()
        coach2.id = Coach.getId()
        coach2.fullName = "Anna Ivanova"
        coach2.category = "Yoga"
        coach2.experience = 5
        coach2.rankType = 1
        coach2.phone = "+380 (99) 978 02 89"
        coach2.email = "anna.ivanova@gmail.com"
        
        let coach3 = Coach()
        coach3.id = Coach.getId()
        coach3.fullName = "Alena Petrova"
        coach3.category = "Yoga"
        coach3.experience = 10
        coach3.rankType = 2
        coach3.phone = "+380 (99) 978 67 76"
        coach3.email = "alena.petrova@gmail.com"
        
        // Swimming
        let coach4 = Coach()
        coach4.id = Coach.getId()
        coach4.fullName = "Alex Chumak"
        coach4.category = "Swimming"
        coach4.experience = 3
        coach4.rankType = 0
        coach4.phone = "+380 (99) 978 02 78"
        coach4.email = "alex.chumak@gmail.com"
        
        let coach5 = Coach()
        coach5.id = Coach.getId()
        coach5.fullName = "Kate Tkach"
        coach5.category = "Swimming"
        coach5.experience = 5
        coach5.rankType = 1
        coach5.phone = "+380 (99) 567 07 89"
        coach5.email = "kate.tkach@gmail.com"
        
        let coach6 = Coach()
        coach6.id = Coach.getId()
        coach6.fullName = "Serhiy Chulsk"
        coach6.category = "Swimming"
        coach6.experience = 10
        coach6.rankType = 2
        coach6.phone = "+380 (99) 890 32 67"
        coach6.email = "serhiy.chulsk@gmail.com"
        
        // Gymnastics
        let coach7 = Coach()
        coach7.id = Coach.getId()
        coach7.fullName = "Kate Chulska"
        coach7.category = "Gymnastics"
        coach7.experience = 3
        coach7.rankType = 0
        coach7.phone = "+380 (99) 678 90 21"
        coach7.email = "kate.chulska@gmail.com"
        
        let coach8 = Coach()
        coach8.id = Coach.getId()
        coach8.fullName = "Andrei Chuprina"
        coach8.category = "Gymnastics"
        coach8.experience = 5
        coach8.rankType = 1
        coach8.phone = "+380 (99) 678 34 89"
        coach8.email = "andrei.chuprina@gmail.com"
        
        let coach9 = Coach()
        coach9.id = Coach.getId()
        coach9.fullName = "Marya Sobko"
        coach9.category = "Gymnastics"
        coach9.experience = 10
        coach9.rankType = 2
        coach9.phone = "+380 (99) 978 67 76"
        coach9.email = "marya.sobko@gmail.com"
        
        // Dance
        let coach10 = Coach()
        coach10.id = Coach.getId()
        coach10.fullName = "Lena Chumak"
        coach10.category = "Dance"
        coach10.experience = 3
        coach10.rankType = 0
        coach10.phone = "+380 (99) 978 02 76"
        coach10.email = "lena.chumak@gmail.com"
        
        let coach11 = Coach()
        coach11.id = Coach.getId()
        coach11.fullName = "Oleksiy Atamanyuk"
        coach11.category = "Dance"
        coach11.experience = 5
        coach11.rankType = 1
        coach11.phone = "+380 (99) 978 02 89"
        coach11.email = "oleksiy.atamanyuk@gmail.com"
        
        let coach12 = Coach()
        coach12.id = Coach.getId()
        coach12.fullName = "Alena Atamanyuk"
        coach12.category = "Dance"
        coach12.experience = 10
        coach12.rankType = 2
        coach12.phone = "+380 (99) 978 67 76"
        coach12.email = "alena.atamanyuk@gmail.com"
        
        // Box
        let coach13 = Coach()
        coach13.id = Coach.getId()
        coach13.fullName = "Vika Karpenko"
        coach13.category = "Box"
        coach13.experience = 3
        coach13.rankType = 0
        coach13.phone = "+380 (99) 978 02 76"
        coach13.email = "vika.karpenko@gmail.com"
        
        let coach14 = Coach()
        coach14.id = Coach.getId()
        coach14.fullName = "Oleksiy Ivanova"
        coach14.category = "Box"
        coach14.experience = 5
        coach14.rankType = 1
        coach14.phone = "+380 (99) 978 02 89"
        coach14.email = "oleksiy.ivanova@gmail.com"
        
        let coach15 = Coach()
        coach15.id = Coach.getId()
        coach15.fullName = "Alex Petrov"
        coach15.category = "Box"
        coach15.experience = 10
        coach15.rankType = 2
        coach15.phone = "+380 (99) 978 67 76"
        coach15.email = "alex.petrov@gmail.com"
    

        self.coachesForPopulate[coach1.id] = coach1
        self.coachesForPopulate[coach2.id] = coach2
        self.coachesForPopulate[coach3.id] = coach3
        
        self.coachesForPopulate[coach4.id] = coach4
        self.coachesForPopulate[coach5.id] = coach5
        self.coachesForPopulate[coach6.id] = coach6
        
        self.coachesForPopulate[coach7.id] = coach7
        self.coachesForPopulate[coach8.id] = coach8
        self.coachesForPopulate[coach9.id] = coach9
        
        self.coachesForPopulate[coach10.id] = coach10
        self.coachesForPopulate[coach11.id] = coach11
        self.coachesForPopulate[coach12.id] = coach12
        
        self.coachesForPopulate[coach13.id] = coach13
        self.coachesForPopulate[coach14.id] = coach14
        self.coachesForPopulate[coach15.id] = coach15
    }

    func populateClientsForDB() {
        
        let client1 = Client()
        client1.id = Client.getId()
        client1.fullName = "Elena Karpenko"
        client1.email = "lena.karpenko@gmail.com"
        let client2 = Client()
        client2.id = Client.getId()
        client2.fullName = "Alex Sobko"
        client2.email = "alex.sobko@gmail.com"
        let client3 = Client()
        client3.id = Client.getId()
        client3.fullName = "Anna Popa"
        client3.email = "anna.popa@gmail.com"
        let client4 = Client()
        client4.id = Client.getId()
        client4.fullName = "Julia Chubaka"
        client4.email = "julia.chubaka@gmail.com"

        self.clientsForPopulate[client1.id] = client1
        self.clientsForPopulate[client2.id] = client2
        self.clientsForPopulate[client3.id] = client3
        self.clientsForPopulate[client4.id] = client4
    }
}
