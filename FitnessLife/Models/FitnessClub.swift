//
//  FitnessClub.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/18/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import UIKit

enum City {
    case Kyiv
    case Vinnytsia
    case Dnipro
    case Lviv
    case Odesa
    case Kharkiv
}

// compani -> fitnessClub -> coach -> client

class FitnessClub: NSObject {
    var name: String
    var city: City
    var address: String
    
    var coaches = [Coach]()
    
    init(_ name: String, _ city: City, _ address: String) {
        self.name = name
        self.city = city
        self.address = address
    }
    
    func addCoach(_ coach: Coach) -> Bool {
        coaches.append(coach)
        return true
    }
    

}
