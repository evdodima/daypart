//
//  Utils.swift
//  DayPart
//
//  Created by evdodima on 01/12/2016.
//  Copyright © 2016 Evdodima. All rights reserved.
//

import Foundation

func countInterval(endingDate: Date, beginingDate:Date) -> String{
    var duration = endingDate.timeIntervalSince(beginingDate)
    
    if duration < 0 {
        duration = endingDate.addingTimeInterval(86400)
            .timeIntervalSince(beginingDate)
    }
    var result = ""
    
    let hours = Int(duration / 3600)
    let minutes = Int(duration.truncatingRemainder(dividingBy: 3600)/60)
    
    result = (hours == 0 ?"":(String(hours) + "h ")) +
        (minutes == 0 ?"":(String(minutes) + "m"))
    if hours == 0 && minutes == 0 {
        result = "0m"
    }
    return result
}

extension Date {
    func asTodayDate() -> Date{
        let cal = Calendar(identifier:.gregorian)
        let h = cal.component(.hour, from: self)
        let m = cal.component(.minute, from: self)
        if let date = cal.date(bySettingHour: h, minute: m, second: 0, of: Date()){
            return date
        }
        return self.addingTimeInterval(-self.timeIntervalSince(Date()))
    }
}
