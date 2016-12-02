//
//  ViewController.swift
//  DayPart
//
//  Created by evdodima on 30/11/2016.
//  Copyright © 2016 Evdodima. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var beginingDatePicker: UIDatePicker!
    @IBOutlet weak var endingDatePicker: UIDatePicker!
    @IBOutlet weak var durationLabel: UILabel!
    let userDef = UserDefaults(suiteName: "group.dayPart")

    @IBAction func beginingValueChange(_ sender: Any) {
        let beginingDate = beginingDatePicker.date
        userDef?.set(beginingDate, forKey: "beginingTime")
        updateDuration()
    }
    @IBAction func endingValueChanged(_ sender: Any) {
        let endingDate = endingDatePicker.date
        userDef?.set(endingDate, forKey: "endingTime")
        updateDuration()
    }
    
    func updateDuration(){
        var duration = endingDatePicker.date.asTodayDate()
            .timeIntervalSince(beginingDatePicker.date.asTodayDate())
        
        if duration < 0 {
            duration = endingDatePicker.date.asTodayDate().addingTimeInterval(86400)
                .timeIntervalSince(beginingDatePicker.date.asTodayDate())
        }
        
        let hours = Int(duration / 3600)
        let minutes = Int(duration.truncatingRemainder(dividingBy: 3600)/60)
        
        durationLabel.text = (hours == 0 ?"":(String(hours) + "h ")) +
             (minutes == 0 ?"":(String(minutes) + "m"))
        if hours == 0 && minutes == 0 {
            durationLabel.text = "0m"
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        beginingDatePicker.minuteInterval = 15
        endingDatePicker.minuteInterval = 15
        updateDuration()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        beginingDatePicker.setDate(userDef?.object(forKey: "beginingTime") as! Date, animated: animated)
        endingDatePicker.setDate(userDef?.object(forKey: "endingTime") as! Date, animated: animated)
        updateDuration()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

