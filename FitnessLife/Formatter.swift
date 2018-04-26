//
//  Formatter.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/22/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//

import Foundation

func stringFromDate(_ date: Date) -> String {
    let df = DateFormatter()
    df.dateFormat = "yyyy/MM/dd hh:mm:ss"
    return df.string(from: date)
}

func dateFromString(_ str: String) -> Date {
    let df = DateFormatter()
    df.dateFormat = "yyyy/MM/dd hh:mm:ss"
    return df.date(from: str)!
}

func dayOfWeekFromDate(_ date: Date) -> Int {
    let myCalendar = Calendar(identifier: .gregorian)
    let weekDay = myCalendar.component(.weekday, from: date)
    return weekDay
}
