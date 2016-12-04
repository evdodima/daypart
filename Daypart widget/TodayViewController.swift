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
    
    @IBOutlet weak var willStartLabel: UILabel!
    @IBOutlet weak var willStartTime: UILabel!
    
    var beginingTime: Date!
    var endingTime: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 60)
        progressView.trackTintColor = UIColor.clear
        progressView.tintColor = UIColor.clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       updateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateDayPart), userInfo: nil, repeats: true);
        updateTimer!.fire()
        updateDayPart()

    }
    override func viewWillDisappear(_ animated: Bool) {
        updateTimer!.invalidate()
    }

    @IBAction func widgetPressed(_ sender: Any) {
        let url: URL = URL(string:"DayPart://")!
        self.extensionContext?.open(url, completionHandler: nil)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        updateDayPart()
        completionHandler(NCUpdateResult.newData)
    }
    
    func countDayPart()-> Double {
        let calendar = Calendar(identifier: .gregorian)
        
        let defaultBegining = calendar.date(bySettingHour: 7, minute: 30, second: 0, of: Date())
        let defaultEnding = calendar.date(bySettingHour: 23, minute: 30, second: 0, of: Date())
        
        beginingTime = (userDef?.object(forKey: "beginingTime") as? Date) ?? defaultBegining!
        endingTime = (userDef?.object(forKey: "endingTime") as? Date) ?? defaultEnding!
        
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
        let dayPartPercent = (Double(dayInterval)/allDay) * 100
        let roundedDayPart = (dayPartPercent * 100).rounded() / 100
        
        return roundedDayPart
    }
    
    func updateDayPart(){
        let dayPart = countDayPart()
        let progressColor = UIColor(hue: CGFloat((170.0/360.0) * (1.0 - (dayPart / 100.0))), saturation: 0.46, brightness: 0.85, alpha: 1.0)

        var labelText = "WTF"
        if dayPart <= 0.0 || dayPart >= 100.0 {
               willStartTime.text = countInterval(endingDate: beginingTime, beginingDate: Date())
                willStartLabel.isHidden = false
                willStartTime.isHidden = false
                dayPartLabel.isHidden = true
            
            progressView.trackTintColor = UIColor.clear
        } else {
            labelText = String(dayPart) + "%"
            willStartLabel.isHidden = true
            willStartTime.isHidden = true
            dayPartLabel.isHidden = false
            progressView.progressTintColor = progressColor
        }
        dayPartLabel.text = labelText
        progressView.setProgress(Float(dayPart / 100), animated: false)
    }
    
    
    
}
