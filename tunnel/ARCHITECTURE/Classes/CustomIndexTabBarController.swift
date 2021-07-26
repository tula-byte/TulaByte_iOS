//
//  CustomIndexTabBarController.swift
//  tunnel
//
//  Created by Arjun Singh on 5/4/21.
//

import UIKit
import SwiftyStoreKit

class CustomIndexTabBarController: UITabBarController {
    
    @IBInspectable var defaultIndex:Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
        
        //redirect back to the onboarding screen if necessary
        if (defaults.value(forKey: "completedOnboarding") as! Bool) != true {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(identifier: "onboarding")
            UIApplication.shared.windows.first?.rootViewController = newVC
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
        
        //check if sub is valid
        if (defaults.value(forKey: nwConnectedKey) as! Bool) == true {
            SwiftyStoreKit.verifyReceipt(using: AppleValidator) { (receiptResult) in
                switch receiptResult {
                case .success(receipt: let receipt):
                    let purchaseResult = SwiftyStoreKit.verifySubscriptions(ofType: .autoRenewable, productIds: Set(Subscriptions), inReceipt: receipt)
                    
                    switch purchaseResult {
                    case .purchased( _, _):
                        defaults.setValue(true, forKey: hasUserPurchasedKey)
                        break
                        
                    case .notPurchased:
                        defaults.setValue(true, forKey: hasUserPurchasedKey)
                        self.enablePaywall()
                        
                    case .expired(_, _):
                        defaults.setValue(true, forKey: hasUserPurchasedKey)
                        let ac = UIAlertController(title: "Subscription Expired", message: "Your subscription has expired. Please resubscribe to continue using the TulaByte app.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) in
                            self.enablePaywall()
                        }))
                        self.present(ac, animated: true, completion: nil)
                        
                    /*
                     TunnelController.shared.deleteManager()
                     let storyboard = UIStoryboard(name: "Main", bundle: nil)
                     let newVC = storyboard.instantiateViewController(identifier: "onboarding")
                     newVC.modalPresentationStyle = .fullScreen
                     self.present(newVC, animated: true, completion: nil)
                     */
                    }
                    
                case .error(error: let error):
                    let ac = UIAlertController(title: "Error", message: "Something went wrong. Please restart the app. \(error)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(ac, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    func enablePaywall() {
        TunnelController.shared.deleteManager()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(identifier: "onboarding")
        UIApplication.shared.windows.first?.rootViewController = newVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
