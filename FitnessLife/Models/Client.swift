//
//  Client.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/22/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit
import RealmSwift

typealias ClientData = (title: String, value: String)

enum ClientType {
    case privateType
    case corporateType
}

protocol IClient {
    var id: Int {get set}
    var fullName: String {get set}
    var createDate: Date {get set}
    var schedule: List<ScheduleItem> {get set}
    func showInfo()
}

class Client: Object {
    @objc dynamic static var lastId = 0
    static func getId() -> Int {
        lastId += 1
        return lastId
    }
}

final class PrivateClient: Client, IClient {

    @objc dynamic var id = -1
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var fullName = "Private client"
    @objc dynamic var createDate = Date()
    @objc dynamic var phone = "Default private phone"
    @objc dynamic var email = "Default private email"
    @objc dynamic var address = "Default private address"
    var schedule = List<ScheduleItem>()
    
    func showInfo() {
        print("Type: Private client")
        print("Full name: " + fullName)
        print("Phone: " + phone)
        print("Email: " + email)
        print("Address: " + address)
    }
}

final class CorporateClient: Client, IClient {

    @objc dynamic var id = -1
    override static func primaryKey() -> String? {
        return "id"
    }
    @objc dynamic var fullName = "Corporate client"
    @objc dynamic var createDate = Date()
    @objc dynamic var companyName = "Default company name"
    @objc dynamic var companyPhone = "Default company phone"
    @objc dynamic var companyEmail = "Default company email"
    @objc dynamic var companyAddress = "Default company address"
    var schedule = List<ScheduleItem>()
    
    func showInfo() {
        print("Type: Corporate client")
        print("Full name: " + fullName)
        print("Company name" + companyName)
        print("Phone: " + companyPhone)
        print("Email: " + companyEmail)
        print("Address: " + companyAddress)
    }
}

protocol ICreator {
    func createClient(withFullName fullName: String,
                      withPhone phone: String,
                      withEmail email: String,
                      withAddress address: String,
                      withCompanyName companyName: String?) -> IClient
}

final class PrivateClientCreator: ICreator {
    func createClient(withFullName fullName: String,
                      withPhone phone: String = "Default phone",
                      withEmail email: String = "Default email",
                      withAddress address: String = "Default address",
                      withCompanyName companyName: String? = nil) -> IClient {
        let client = PrivateClient()
        client.id = PrivateClient.getId()
        client.fullName = fullName
        client.phone = phone
        client.email = email
        client.address = address
        return client
    }
}

final class CorporateClientCreator: ICreator {
    func createClient(withFullName fullName: String,
                      withPhone phone: String = "Default company phone",
                      withEmail email: String = "Default company email",
                      withAddress address: String = "Default company address",
                      withCompanyName companyName: String? = "Default company company name") -> IClient {
        let client = CorporateClient()
        client.id = CorporateClient.getId()
        client.fullName = fullName
        client.companyPhone = phone
        client.companyEmail = email
        client.companyAddress = address
        client.companyName = companyName!
        return client
    }
}
