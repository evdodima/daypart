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
        progressView.transform = progressView.transform.scaledBy(x: 1, y: self.view.frame.height/2)
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
        userDef?.set(true, forKey: "widgetInstalled")
    }
    override func viewWillDisappear(_ animated: Bool) {
        updateTimer!.invalidate()
    }

//    func widgetPressed(_ sender: Any) {
//        let url: URL = URL(string:"DayPart://")!
//        self.extensionContext?.open(url, completionHandler: nil)
//    }
    
    @IBAction func widgetPressed(_ sender: UIButton) {
        let url: URL = URL(string:"DayPart://")!
        self.extensionContext?.open(url, completionHandler: nil)
    }
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        updateDayPart()
        completionHandler(NCUpdateResult.newData)
    }
    
    func updateDayPart(){
        let beginingTime = userDef?.object(forKey: "beginingTime") as! Date
        let dayPart = countDayPart()
        let progressColor = UIColor(hue: CGFloat((120.0/360.0) * (dayPart / 100.0)), saturation: 0.46, brightness: 0.85, alpha: 1.0)
        

        var labelText = "WTF"
        if dayPart <= 0.0 || dayPart >= 100.0 {
               willStartTime.text = countInterval(endingDate: beginingTime.asTodayDate(), beginingDate: Date())
                willStartLabel.isHidden = false
                willStartTime.isHidden = false
                dayPartLabel.isHidden = true
            
            progressView.trackTintColor = UIColor.clear
            progressView.progressTintColor = UIColor.clear
        } else {
            labelText = String(dayPart) + "%"
            willStartLabel.isHidden = true
            willStartTime.isHidden = true
            dayPartLabel.isHidden = false
            progressView.progressTintColor = progressColor
        }
        dayPartLabel.text = labelText.replacingOccurrences(of: ".0%", with: "%")
        progressView.setProgress(Float(dayPart / 100), animated: false)
    }
    
    
    
}
