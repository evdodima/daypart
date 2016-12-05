//
//  IntroViewController.swift
//  DayPart
//
//  Created by evdodima on 05/12/2016.
//  Copyright © 2016 Evdodima. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet weak var myButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myButton.titleLabel?.minimumScaleFactor = 0.1;
        self.myButton.titleLabel?.numberOfLines = 0;
        self.myButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        myButton.titleLabel?.lineBreakMode = .byClipping;

        // Do any additional setup after loading the view.
    }

    @IBAction func gotItPressed(_ sender: UIButton) {
               self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userDef?.set(true, forKey: "IntroAppeared")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
