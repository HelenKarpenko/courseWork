//
//  UserCreator.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 5/1/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

protocol IUserCreator {
    func createUser(withFullName fullname: String,
                    withPhone phone: String,
                    withEmail email: String,
                    withAddress address: String,
                    withPassword password: String) -> IUser
}

class ClientCreator: IUserCreator  {
    func createUser(withFullName fullname: String,
                    withPhone phone: String = "",
                    withEmail email: String = "",
                    withAddress address: String = "",
                    withPassword password: String = "") -> IUser {
        let client = Client()
        client.id = Client.getId()
        client.fullName = fullname
        client.phone = phone
        client.email = email
        client.address = address
        client.password = password
        return client
    }
}

class CoachCreator: IUserCreator  {
    func createUser(withFullName fullname: String,
                    withPhone phone: String = "",
                    withEmail email: String = "",
                    withAddress address: String = "",
                    withPassword password: String = "") -> IUser {
        let coach = Coach()
        coach.id = Coach.getId()
        coach.fullName = fullname
        coach.phone = phone
        coach.email = email
        coach.address = address
        coach.password = password
        return coach
    }
}
