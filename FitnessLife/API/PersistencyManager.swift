//
//  PersistencyManager.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/22/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import Foundation

final class PersistencyManager {
    
    private var coaches = [Coach]()
//    private var clients = [IClient]()
    
    init() {
//        HTTPClient.shared.getAllCoaches(
//            onSuccess: { coaches in
//                DispatchQueue.main.async {
//                    self.coaches = coaches
//                }
//        }, onFailure: { error in
//            print(error)
//        })
    }
    
//    func populateClients() {
//        let client1 = Client(1, "Elena Karpenko", .personal)
//        let client2 = Client(2, "Alex Ivanov", .personal)
//        let client3 = Client(3, "Anna Flower", .personal)
//        let client4 = Client(4, "Julia Chubaka", .personal)
//        
//        self.clients.append(client1)
//        self.clients.append(client2)
//        self.clients.append(client3)
//        self.clients.append(client4)
//    }
    
    func getCoaches() -> [Coach] {
        return coaches
    }
    
    func addCoach(_ coach: Coach, at index: Int) {
        if (coaches.count >= index) {
            coaches.insert(coach, at: index)
        } else {
            coaches.append(coach)
        }
    }
    
    func deleteCoach(at index: Int) {
        coaches.remove(at: index)
    }
}
