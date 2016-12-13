//
//  UpgradeToProViewController.swift
//  DayPart
//
//  Created by evdodima on 13/12/2016.
//  Copyright © 2016 Evdodima. All rights reserved.
//

import UIKit

class UpgradeToProViewController: UIViewController {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var laterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoView.clipsToBounds = true
        infoView.layer.cornerRadius = 7
        
        upgradeButton.layer.cornerRadius = 7
        laterButton.layer.cornerRadius = 7

        // Do any additional setup after loading the view.
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
