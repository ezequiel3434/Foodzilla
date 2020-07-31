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
    
    func loadProducts() {
        productIdToStringSet()
        requestProducts(forIds: productIds)
        
    }
    
    func productIdToStringSet() {
        productIds.insert(IAP_MEAL_ID)
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
}



extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                debugPrint("Purchase was successful!")
                break
            case .restored:
                break
            case .failed:
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
}


