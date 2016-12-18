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
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var laterButton: UIButton!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let appStore = AppDelegate.appStore

    
    
    var buyTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upgradeButton.titleLabel?.minimumScaleFactor = 0.1;
        upgradeButton.titleLabel?.numberOfLines = 0;
        upgradeButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        upgradeButton.titleLabel?.lineBreakMode = .byClipping;

        
        infoView.clipsToBounds = true
        infoView.layer.cornerRadius = 7
        
        upgradeButton.layer.cornerRadius = 7
        laterButton.layer.cornerRadius = 7

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.purchasingNotification(notification:)),
                                               name: appStore.purchasingNotification, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didPurchaseNotification(notification:)),
                                               name: appStore.purchasedNotification, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didFailPurchaseNotification(notification:)),
                                               name: appStore.failPurchaseNotification, object: nil)
        if let pro = AppStore.proUserProduct {
            updateUI(product: pro)
        } else {
            requestProduct()
        }
        activityView.isHidden = true
    }
    
    
    func purchasingNotification(notification: Notification) {
        print("purchasingNotification")
        activityView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func didPurchaseNotification(notification: Notification) {
        print("didPurchaseNotification")
        activityView.isHidden = true
        activityIndicator.stopAnimating()
        buyTapped = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func didFailPurchaseNotification(notification: Notification) {
        
        if let msg = notification.userInfo?["msg"] as? String {
            showInfoAlert(UIAlertController(title: "Something went wrong",
                                            message: msg, preferredStyle: .alert))
        }
        buyTapped = false
        activityView.isHidden = true
        activityIndicator.stopAnimating()
    }

    @IBAction func laterPressed(_ sender: Any) {
        buyTapped = false
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func restorePressed(_ sender: Any) {
        print("restorePressed")
            activityView.isHidden = false
            activityIndicator.startAnimating()
            appStore.restorePurchases()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.stopTimer()
        }
    }
    
    func stopTimer(){
        activityView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    @IBAction func upgradePressed(_ sender: Any) {
        print("upgradePressed")
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
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
