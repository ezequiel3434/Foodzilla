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
            requestProducts(forIds: productIds)
        } else {
            delegate?.iapProductsLoaded()
        }
    }
}



