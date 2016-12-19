//
//  MainDaypartViewController.swift
//  DayPart
//
//  Created by evdodima on 12/12/2016.
//  Copyright © 2016 Evdodima. All rights reserved.
//

import UIKit

class MainDaypartViewController: UIViewController {

    
    var updateTimer: Timer? = nil
    
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var willStartTime: UILabel!
    @IBOutlet weak var dayPartLabel: UILabel!
    @IBOutlet weak var willStartLabel: UILabel!

    @IBOutlet weak var progressHeight: NSLayoutConstraint!
    
    
    
    
    
    @IBAction func editDay(_ sender: Any) {
        showDayPart()
    }
    
    @IBAction func showIntro(_ sender: UIButton) {
        showIntro()
    }
    override func viewDidLoad() {
        let calendar = Calendar(identifier: .gregorian)
        let defaultBegining = calendar.date(bySettingHour: 7, minute: 30, second: 0, of: Date())
        let defaultEnding = calendar.date(bySettingHour: 23, minute: 30, second: 0, of: Date())
        
        super.viewDidLoad()
        if let _ = userDef?.object(forKey: "beginingTime")
            , let _ = userDef?.object(forKey: "endingTime")  {
        }
        else {
            userDef?.set(defaultBegining, forKey: "beginingTime")
            userDef?.set(defaultEnding, forKey: "endingTime")
        }
        progressView.backgroundColor = UIColor.clear
    }
    override func viewWillDisappear(_ animated: Bool) {
        updateTimer!.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateDayPart), userInfo: nil, repeats: true);
        updateTimer!.fire()
        updateDayPart()
    }
    
    override func viewDidAppear(_ animated: Bool) {
                if userDef?.object(forKey: "IntroAppeared") == nil {
                    showIntro()
                }
//        if let fromWidget = userDef?.bool(forKey: "fromWidget"){
//            if fromWidget {
//                showDayPart()
//                userDef?.set(false, forKey: "fromWidget")
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showDayPart(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "dayPart")
        self.present(controller, animated: true, completion: nil)
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
            progressView.backgroundColor = .clear
            
        } else {
            labelText = String(dayPart) + "%"
            willStartLabel.isHidden = true
            willStartTime.isHidden = true
            dayPartLabel.isHidden = false
            progressView.backgroundColor = progressColor
        }
        dayPartLabel.text = labelText.replacingOccurrences(of: ".0%", with: "%")
        changeProgress(daypart: Float(dayPart))
    }
    
    func showIntro(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "intro")
        self.present(controller, animated: true, completion: nil)
    }
    
    func changeProgress(daypart: Float){
        let viewHeight = self.view.frame.height
        if daypart > 0 {
            progressHeight.constant = viewHeight * CGFloat(daypart/100)
        }
        self.view!.layoutIfNeeded()

    }
}
