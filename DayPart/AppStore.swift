//
//  AppStore.swift
//
//
//  Created by Salavat Khanov on 8/19/16.
//  Copyright © 2016 Salavat Khanov. All rights reserved.
//
import Foundation
import StoreKit

class AppStore: NSObject {
    
    static var proUserProduct: SKProduct? = nil
    let queue = SKPaymentQueue.default()
    typealias ProductsRequestCompletionHandler = (_ success: Bool, _ pro: SKProduct?) -> ()
    
    var iapID: String { return "evdodima.DayPart.DayAdjusting" }
    var purchasedNotification: NSNotification.Name { return NSNotification.Name(rawValue: "AppStorePurchasedNotification") }
    var purchasingNotification: NSNotification.Name { return NSNotification.Name(rawValue: "AppStorePurchasingNotification") }
    var failPurchaseNotification: NSNotification.Name { return NSNotification.Name(rawValue: "AppStoreFailPurchaseNotification") }
    
    fileprivate var productsRequest: SKProductsRequest?
    fileprivate var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    override init() {
        super.init()
        queue.add(self)
    }
}

// MARK: - SKProductsRequestDelegate
extension AppStore: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let pro = response.products.filter { $0.productIdentifier == iapID }.first
        print("Got product info for \(pro?.productIdentifier)")
        AppStore.proUserProduct = pro == nil ? AppStore.proUserProduct : pro
        productsRequestCompletionHandler?(true, pro)
        clearRequestAndHandler()
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        // TODO: Show error alert
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
    
}

// MARK: - SKPaymentTransactionObserver
extension AppStore: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                completeTransaction(transaction: transaction)
                break
            case .failed:
                failedTransaction(transaction: transaction)
                break
            case .restored:
                restoreTransaction(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                purchasingTransaction(transaction: transaction)
            }
        }
    }
    
    private func completeTransaction(transaction: SKPaymentTransaction) {
        deliverPurchaseNotificatioForIdentifier(identifier: transaction.payment.productIdentifier)
        queue.finishTransaction(transaction)
    }
    
    private func restoreTransaction(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        deliverPurchaseNotificatioForIdentifier(identifier: productIdentifier)
        queue.finishTransaction(transaction)
    }
    
    private func failedTransaction(transaction: SKPaymentTransaction) {
        var msg: String? = nil
        if (transaction.error as! NSError).code != SKError.paymentCancelled.rawValue {
            msg = transaction.error?.localizedDescription ?? "Unknown Error"
        }
        
        NotificationCenter.default.post(name: failPurchaseNotification,
                                        object: transaction.transactionIdentifier,
                                        userInfo: ["msg": msg!])
        print("Transaction Error: \(msg)")
        
        queue.finishTransaction(transaction)
    }
    
    private func purchasingTransaction(transaction: SKPaymentTransaction) {
        NotificationCenter.default.post(name: purchasingNotification, object: transaction.transactionIdentifier)
    }
    
    private func deliverPurchaseNotificatioForIdentifier(identifier: String?) {
        guard let identifier = identifier else { return }
        
        isProUser = true
        NotificationCenter.default.post(name: purchasedNotification, object: identifier)
    }
}


extension AppStore {
    
    // background, silent version to pre-cache product
    func requestProductsSilently() {
        if productsRequest == nil && !isProUser {
            print("Precaching IAP product")
            productsRequest = SKProductsRequest(productIdentifiers: [iapID])
            productsRequest!.delegate = self
            productsRequest!.start()
        }
    }
    
    // force request again
    func requestProducts(completionHandler: ProductsRequestCompletionHandler) {
        
        if let pro = AppStore.proUserProduct {
            return completionHandler(true, pro)
        }
        
        print("Force requesting product")
        
        productsRequest?.cancel()
        
        productsRequest = SKProductsRequest(productIdentifiers: [iapID])
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    func buy(product: SKProduct) {
        queue.add(SKPayment(product: product))
    }
    
    var canMakePayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func restorePurchases() {
        queue.restoreCompletedTransactions()
    }
    
    func localizedPrice(forProduct product: SKProduct) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        return numberFormatter.string(from: product.price)
    }
    
    var isProUser: Bool {
        get {
            return userDef!.bool(forKey: iapID)
        }
        set {
            userDef?.set(newValue, forKey: iapID)
            userDef?.synchronize()
        }
    }
    
}
