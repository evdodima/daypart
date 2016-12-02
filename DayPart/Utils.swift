//
//  Utils.swift
//  DayPart
//
//  Created by evdodima on 01/12/2016.
//  Copyright © 2016 Evdodima. All rights reserved.
//

import Foundation



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
