//
//  IAPService.swift
//  Foodzilla
//
//  Created by Ezequiel Parada Beltran on 30/07/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import Foundation
import StoreKit


protocol IAPServiceDelegate {
    func iapProductsLoaded()
}



class IAPService: NSObject, SKProductsRequestDelegate {
        
    static let instance = IAPService()
    
    var delegate: IAPServiceDelegate?
    
    var products = [SKProduct]()
    var productIds = Set<String>()
    var productRequest = SKProductsRequest()
    
    var nonConsumablePurchaseWasMade = UserDefaults.standard.bool(forKey: "nonConsumablePurchaseWasMade")
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    
    func loadProducts() {
        productIdToStringSet()
        requestProducts(forIds: productIds)
        
    }
    
    func productIdToStringSet() {
        let ids = [IAP_HID_ADS_ID, IAP_MEAL_ID, IAP_MEALTIME_MONTHLY_SUB ]
        for id in ids {
            productIds.insert(id)
        }
        
    }
    
    func requestProducts(forIds ids: Set<String>) {
        
        productRequest.cancel()
        productRequest = SKProductsRequest(productIdentifiers: ids)
        productRequest.delegate = self
        productRequest.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        
        if products.count == 0 {
            print("no recibi nada")
            requestProducts(forIds: productIds)
            
        } else {
            delegate?.iapProductsLoaded()
            print(products[0].localizedTitle)
        }
    }
    
    func attemptPurchaseForItemWith(productIndex: Product) {
        let product = products[productIndex.rawValue]
        let payment = SKPayment(product: product)
        
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
        
     
    }
    
    func uploadReceipt(completionHandler: @escaping (Bool) -> Void ) {
        guard let receiptUrl = Bundle.main.appStoreReceiptURL, let receipt = try? Data(contentsOf: receiptUrl).base64EncodedString() else {
            debugPrint("No receipt Url")
            completionHandler(false)
            return }
        
        let body = [
            "receipt-data": receipt,
            "paasword": appSecret
        ]
        
        let bodyData = try! JSONSerialization.data(withJSONObject: body, options: [])
        
        let url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: request) { (responseData, response, error) in
            if let error = error {
                debugPrint("ERROR: ", error)
                completionHandler(false)
            } else if let responseData = responseData {
                let json = try! JSONSerialization.jsonObject(with: responseData, options: [])
                print(json)
                completionHandler(true)
            }
        }
        
        task.resume()
    }
    
}


//MARK: PAyment requests
extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                complete(transaction: transaction)
                
                debugPrint("Purchase was successful!")
                break
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                sendNotificationFor(status: .failed, withIdentifier: nil, orBoolean: nil)
                break
            case .deferred:
                break
            case .purchasing:
                break
            default:
                break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        sendNotificationFor(status: .restored, withIdentifier: nil, orBoolean: nil)
        setNonConsumablePurchase(true)
    }
    
    func complete(transaction: SKPaymentTransaction) {
        switch transaction.payment.productIdentifier {
        case IAP_MEALTIME_MONTHLY_SUB:
//            uploadReceipt { (valid) in
//                if valid {
//                    debugPrint("Subscription is totally valid")
//                } else {
//                    debugPrint("Doesn't look like you bought this.")
//                }
//            }
            sendNotificationFor(status: .subscribed, withIdentifier: transaction.payment.productIdentifier, orBoolean: true)
            setNonConsumablePurchase(true)
            break
        case IAP_MEAL_ID:
            sendNotificationFor(status: .purchased, withIdentifier: transaction.payment.productIdentifier, orBoolean: nil)
            break
        case IAP_HID_ADS_ID:
            setNonConsumablePurchase(true)
            break
        default:
            break
        }
    }
    
    func setNonConsumablePurchase(_ status: Bool){
        UserDefaults.standard.set(status, forKey: "nonConsumablePurchaseWasMade")
    }
    

    //MARK: Notifications
    
    func sendNotificationFor(status: PurchaseStatus, withIdentifier identifier: String?, orBoolean bool: Bool?) {
        switch status {
        case .purchased:
            NotificationCenter.default.post(name: NSNotification.Name.init(IAPServicePurchaseNotification) , object: identifier)
            break
        case .restored:
            NotificationCenter.default.post(name: NSNotification.Name.init(IAPServiceRestoreNotification) , object: nil)
            break
        case .failed:
             NotificationCenter.default.post(name: NSNotification.Name.init(IAPServiceFailureNotification) , object: nil)
            break
       
        case .subscribed:
            NotificationCenter.default.post(name: NSNotification.Name.init(IAPSubInfoChangedNotification), object: bool)
            break
        }
    }
    
}


