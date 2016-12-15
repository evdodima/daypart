//
//  UpgradeToProViewController.swift
//  DayPart
//
//  Created by evdodima on 13/12/2016.
//  Copyright © 2016 Evdodima. All rights reserved.
//

import UIKit
import StoreKit

class UpgradeToProViewController: UIViewController {
    
    var appStore: AppStore! = AppStore()

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var laterButton: UIButton!
    
    var buyTapped = false
    
    override func viewDidLoad() {
        appStore.requestProductsSilently()
        super.viewDidLoad()
        
        infoView.clipsToBounds = true
        infoView.layer.cornerRadius = 7
        
        upgradeButton.layer.cornerRadius = 7
        laterButton.layer.cornerRadius = 7

        // Do any additional setup after loading the view.
    }

    @IBAction func laterPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func restorePressed(_ sender: Any) {
            appStore.restorePurchases()
    }
    
    @IBAction func upgradePressed(_ sender: Any) {
        if appStore.canMakePayments {
            if let proUser = AppStore.proUserProduct {
                appStore.buy(product: proUser)
            } else if buyTapped { // already tried buying once
                requestProduct(silently: false)
            }
        } else {
            showInfoAlert(UIAlertController(title: "Something went wrong",
                                            message: "Apparently, you are not allowed to make payments.",
                                            preferredStyle: .alert))
        }
        
        buyTapped = true
    }
    
    
    
    func requestProduct(silently: Bool = true) {
        appStore.requestProducts { [weak self] success, pro in
            if let pro = pro {
                self?.updateUI(product: pro)
                if self?.buyTapped == true {
                    self?.appStore.buy(product: pro)
                }
            } else if !silently {
                self?.showInfoAlert(UIAlertController(title: "Houston, we have a problem!",
                                                      message: "Couldn't request product from App Store.\nPlease try again later.",
                                                      preferredStyle: .alert))
            }
        }
    }
    
    func updateUI(product: SKProduct) {
        if let price = appStore.localizedPrice(forProduct: product) {
            upgradeButton.setTitle("Upgrade for \(price)", for: .normal)
        }
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
