//
//  ViewController.swift
//  DayPart
//
//  Created by evdodima on 30/11/2016.
//  Copyright © 2016 Evdodima. All rights reserved.
//

import UIKit

class DayPartViewController: UIViewController {

    @IBOutlet weak var beginingDatePicker: UIDatePicker!
    @IBOutlet weak var endingDatePicker: UIDatePicker!
    @IBOutlet weak var durationLabel: UILabel!

    @IBAction func beginingChanged(_ sender: Any) {
        updateDuration()
        showPurchasePage()
        
    }
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func endingChanged(_ sender: Any) {
        updateDuration()
        showPurchasePage()
    }
    func updateDuration(){
        durationLabel.text = countInterval(endingDate: endingDatePicker.date.asTodayDate(), beginingDate: beginingDatePicker.date.asTodayDate())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = userDef?.object(forKey: "beginingTime")
            , let _ = userDef?.object(forKey: "endingTime")  {
        }
        else {
            userDef?.set(beginingDatePicker.date, forKey: "beginingTime")
            userDef?.set(endingDatePicker.date, forKey: "endingTime")
        }
        
        beginingDatePicker.minuteInterval = 15
        endingDatePicker.minuteInterval = 15
        updateDuration()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("willAppear")
        beginingDatePicker.setDate(userDef?.object(forKey: "beginingTime") as! Date, animated: animated)
        endingDatePicker.setDate(userDef?.object(forKey: "endingTime") as! Date, animated: animated)
        updateDuration()
    }
    
    func showPurchasePage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "purchase")
        self.present(controller, animated: true, completion: nil)
    }
    func showDayPart(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainDaypart")
        self.present(controller, animated: true, completion: nil)
    }

    @IBAction func saveTimes(_ sender: UIButton) {
        let endingDate = endingDatePicker.date
        userDef?.set(endingDate, forKey: "endingTime")
        updateDuration()
        
        let beginingDate = beginingDatePicker.date
        userDef?.set(beginingDate, forKey: "beginingTime")
        updateDuration()

        
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

