//
//  StoreKitUtilities.swift
//  tunnel
//
//  Created by Arjun Singh on 5/5/21.
//

import Foundation
import SwiftyStoreKit

//product IDs
public let IndividualSubscription = "com.tulabyte.tulabyte.individualSubscription"
public let FamilySubscription = "com.tulabyte.tulabyte.familySubscription"
public let Subscriptions = [IndividualSubscription, FamilySubscription]
public let AppleValidator = AppleReceiptValidator(service: .production, sharedSecret: "5a76908774c14f29b6ec26e8e83631fa")
// This is used due to SwiftyStoreKit code structure. If someone has the techincal knowledge to modify or fake the receipt file, they might as well get the code from GitHub.

//error subscription object
let ErrorSubscription = (product: "Error", price: "$123")

//retrieve the metadata for a given product ID
func addSubscriptionInfoToDefaults(id: String) {
    SwiftyStoreKit.retrieveProductsInfo([id]) { result in
        var priceVal: String = "0.0"
        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice
            print("TB SK:", id, priceString!)
            priceVal = priceString!
        }
        else if result.invalidProductIDs.first != nil {
            priceVal = "12.34"
        } else if result.error != nil {
            NSLog("TB SK: Product couldn't be fetched. \(result.error!.localizedDescription)")
        }
        NSLog("TB SK: \(id) : \(priceVal)")
        defaults.setValue(priceVal, forKey: id)
    }
}

//MARK:- UNUSED FUNCTIONS
/*
// check whether receipt is valid and subscription is current
func isSubscriptionValid() -> Bool {
    var receipt: InAppReceipt!
    //get receipt
    
    do {
        try receipt = InAppReceipt.localReceipt()
    } catch {
        NSLog("TB SK: Receipt couldn't be found.")
        return false
    }
    
    //check if a subscription is active
    var activeSub: Bool {
        if ((receipt.activeAutoRenewableSubscriptionPurchases(ofProductIdentifier: IndividualSubscription, forDate: Date()) != nil) || (receipt.activeAutoRenewableSubscriptionPurchases(ofProductIdentifier: FamilySubscription, forDate: Date()) != nil)) {
            return true
        } else {
            return false
        }
    }
    
    // if receipt exists and sub is currently active
    if receipt != nil && activeSub == true {
        do {
            //verify the receipt
            try receipt.verify()
            return true
        } catch {
            NSLog("TB SK: Invalid Receipt")
            return false
        }
    }
    return false
}

// check whether receipt is valid and subscription is current with receipt refresh
func isSubscriptionValidRefreshed() -> Bool {
    var receipt: InAppReceipt!
    //get receipt
    InAppReceipt.refresh { (error) in
        if error != nil {
            NSLog("TB SK: Receipt could not be refreshed. Error: \(String(describing: error))")
        } else {
            do {
                try receipt = InAppReceipt.localReceipt()
            } catch {
                NSLog("TB SK: Receipt couldn't be found.")
            }
        }
    }
    
    //check if a subscription is active
    var activeSub: Bool {
        if ((receipt.activeAutoRenewableSubscriptionPurchases(ofProductIdentifier: IndividualSubscription, forDate: Date()) != nil) || (receipt.activeAutoRenewableSubscriptionPurchases(ofProductIdentifier: FamilySubscription, forDate: Date()) != nil)) {
            NSLog("TB SK: Found valid subscription")
            return true
        } else {
            NSLog("TB SK: No valid subscription")
            return false
        }
    }
    
    // if receipt exists and sub is currently active
    if receipt != nil && activeSub == true {
        do {
            //verify the receipt
            try receipt.verify()
            NSLog("TB SK: Receipt Validated Good")
            return true
        } catch {
            NSLog("TB SK: Invalid Receipt")
            return false
        }
    }
    return false
}
*/
