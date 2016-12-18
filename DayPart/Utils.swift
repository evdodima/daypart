//
//  Utils.swift
//  DayPart
//
//  Created by evdodima on 01/12/2016.
//  Copyright © 2016 Evdodima. All rights reserved.
//

import Foundation
import UIKit

let userDef = UserDefaults(suiteName: "group.dayPart")


extension UIViewController{
    func showInfoAlert(_ alert: UIAlertController) {
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel) { action in
            alert.dismiss(animated: true)

        })
        present(alert, animated: true, completion: nil)
    }
}


func countDayPart()-> Double {
    let calendar = Calendar(identifier: .gregorian)
    let defaultBegining = calendar.date(bySettingHour: 6, minute: 30, second: 0, of: Date())
    let defaultEnding = calendar.date(bySettingHour: 22, minute: 30, second: 0, of: Date())
    
    var beginingTime = (userDef?.object(forKey: "beginingTime") as? Date) ?? defaultBegining!
    var endingTime = (userDef?.object(forKey: "endingTime") as? Date) ?? defaultEnding!
    
    beginingTime = beginingTime.asTodayDate()
    endingTime = endingTime.asTodayDate()
    
    
    var allDay = endingTime.timeIntervalSince(beginingTime)
    let currentDate = Date()
    var dayInterval = currentDate.timeIntervalSince(beginingTime)
    
    if allDay < 0 {
        allDay += 86400
        if dayInterval < 0 {
            dayInterval += 86400
        }
    }
    let dayPartPercent = (1.0 - Double(dayInterval)/allDay) * 100
    let roundedDayPart = (dayPartPercent * 100).rounded() / 100
    
    return roundedDayPart
}


func countInterval(endingDate: Date, beginingDate:Date) -> String{
    var duration = endingDate.timeIntervalSince(beginingDate) + 1
    
    if duration < 0 {
        duration = endingDate.addingTimeInterval(86400)
            .timeIntervalSince(beginingDate)
    }
    var result = ""
    
    let hours = Int(duration / 3600)
    let minutes = Int(duration.truncatingRemainder(dividingBy: 3600)/60)
    let seconds = Int(duration.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60))
    
    result = (hours == 0 ?"":(String(hours) + "h ")) +
        (minutes == 0 ?"":(String(minutes) + "m"))
    if hours == 0 && minutes == 0 {
        result = String(seconds) + "s"
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

extension NSLayoutConstraint {
    func constraintWithMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
