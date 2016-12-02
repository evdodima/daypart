//
//  TodayViewController.swift
//  Daypart widget
//
//  Created by evdodima on 30/11/2016.
//  Copyright © 2016 Evdodima. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    let userDef = UserDefaults(suiteName: "group.dayPart")
    var updateTimer: Timer? = nil
    
    @IBOutlet weak var dayPartLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 60)
        progressView.trackTintColor = UIColor.clear;

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       updateTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.updateDayPart), userInfo: nil, repeats: true);
        updateTimer!.fire()

    }
    override func viewWillDisappear(_ animated: Bool) {
        updateTimer!.invalidate()
    }

    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        updateDayPart()
        completionHandler(NCUpdateResult.newData)
    }
    
    func countDayPart()-> Double {
        let calendar = Calendar(identifier: .gregorian)
        
        let defaultBegining = calendar.date(bySettingHour: 7, minute: 30, second: 0, of: Date())
        let defaultEnding = calendar.date(bySettingHour: 23, minute: 30, second: 0, of: Date())
        
        var beginingTime: Date = (userDef?.object(forKey: "beginingTime") as? Date) ?? defaultBegining!
        var endingTime: Date = (userDef?.object(forKey: "endingTime") as? Date) ?? defaultEnding!
        
        beginingTime = beginingTime.asTodayDate()
        endingTime = endingTime.asTodayDate()
        
        if endingTime.timeIntervalSince(beginingTime) < 0 {
            endingTime = endingTime.addingTimeInterval(86400)
        }
        
        
        let allDay = endingTime.timeIntervalSince(beginingTime)
        let currentDate = Date()
        let dayInterval = currentDate.timeIntervalSince(beginingTime)
        let dayPartPercent = (Double(dayInterval)/allDay) * 100
        let roundedDayPart = (dayPartPercent * 100).rounded() / 100
        
        return roundedDayPart
    }
    
    func updateDayPart(){
        let dayPart = countDayPart()
        var labelText = "WTF"
        if dayPart <= 0.0 {
            labelText = "Your day didn't started yet"
        } else if dayPart >= 100.0 {
            labelText = "Your day already ended"
        } else {
            labelText = String(dayPart) + "%"
        }
        
        dayPartLabel.text = labelText
        progressView.setProgress(Float(dayPart / 100), animated: false)
    }
    
    
    
}
