//
//  SubscribeViewController.swift
//  tunnel
//
//  Created by Arjun Singh on 30/3/21.
//

import UIKit
import StoreKit
import SwiftyStoreKit

class SubscribeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outSubscribe.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
         Purchases.shared.offerings { (offerings, error) in
         if let individual = offerings?.current?.package(identifier: "individual") {
         self.subscriptions.append(individual)
         self.outIndividual.setTitle("Individual - \(individual.product.localizedPrice ?? "$123")/year", for: .normal)
         self.outIndividual.setTitle("Individual - \(individual.product.localizedPrice ?? "$123")/year", for: .disabled)
         }
         if let family = offerings?.current?.package(identifier: "family"){
         self.subscriptions.append(family)
         self.outFamily.setTitle("Family (Upto 6 People) - \(family.product.localizedPrice ?? "$123")/year", for: .normal)
         self.outFamily.setTitle("Family (Upto 6 People) - \(family.product.localizedPrice ?? "$123")/year", for: .disabled)
         }
         }
         */
        
        let individualPrice = defaults.value(forKey: IndividualSubscription)
        let familyPrice = defaults.value(forKey: FamilySubscription)
        
        outIndividual.setTitle("Individual - \(individualPrice ?? "$1.99")/year", for: .normal)
        outIndividual.setTitle("Individual - \(individualPrice ?? "$1.99")/year", for: .disabled)
        
        outFamily.setTitle("Family (Upto 6 People) - \(familyPrice ?? "$4.99")/year", for: .normal)
        outFamily.setTitle("Family (Upto 6 People) - \(familyPrice ?? "$4.99")/year", for: .disabled)
    }
    
    //variables
    var chosenProduct: String!
    //var subscriptions: [Purchases.Package] = []
    
    //outlets
    @IBOutlet weak var outSubscribe: TulaButton!
    @IBOutlet weak var outIndividual: TulaStateButton!
    @IBOutlet weak var outFamily: TulaStateButton!
    
    @IBOutlet weak var btnInfo: UIButton!
    
    //actions
    @IBAction func btnIndividualSub(_ sender: Any) {
        chosenProduct = Subscriptions[0]
        
        outSubscribe.isEnabled = !outIndividual.isActive
        
        if outFamily.isActive {
            outFamily.isActive = false
            outFamily.setNeedsDisplay()
        }
    }
    
    @IBAction func btnFamilySub(_ sender: Any) {
        chosenProduct = Subscriptions[1]
        
        outSubscribe.isEnabled = !outFamily.isActive
        
        if outIndividual.isActive {
            outIndividual.isActive = false
            outIndividual.setNeedsDisplay()
        }
    }
    
    @IBAction func btnSubscribe(_ sender: Any) {
        present(showLoadingIndicator(), animated: true, completion: nil)
        SwiftyStoreKit.verifyReceipt(using: AppleValidator) { (receiptResult) in
            switch receiptResult {
            case .success(receipt: let receipt):
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(ofType: .autoRenewable, productIds: Set(Subscriptions), inReceipt: receipt)
                print(purchaseResult)
                switch purchaseResult {
                case .purchased( _, _):
                    defaults.setValue(true, forKey: hasUserPurchasedKey)
                    let ac = UIAlertController(title: "Already Subscribed", message: "You already have a valid subscription! There's no need to buy a new subcscription, and you will not be charged again. \n \n You can change your subscription level in the iOS Settings app.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
                        if self.outSubscribe.isEnabled {
                            self.performSegue(withIdentifier: "subscribeToTunnelSetup", sender: self)
                        }
                    }))
                    self.dismiss(animated: true) {
                        self.present(ac, animated: true, completion: nil)
                    }
                    
                case .notPurchased, .expired(_, _):
                    defaults.setValue(false, forKey: hasUserPurchasedKey)
                    SwiftyStoreKit.purchaseProduct(self.chosenProduct, quantity: 1, atomically: true) { result in
                        self.dismiss(animated: true, completion: nil)
                        switch result {
                        case .success(_):
                            SwiftyStoreKit.verifyReceipt(using: AppleValidator) { (receiptResult) in
                                switch receiptResult {
                                case .success(receipt: let receipt):
                                    let purchaseResult = SwiftyStoreKit.verifySubscriptions(ofType: .autoRenewable, productIds: Set(Subscriptions), inReceipt: receipt)
                                    
                                    switch purchaseResult {
                                    case .purchased( _, _):
                                        defaults.setValue(true, forKey: hasUserPurchasedKey)
                                        if self.outSubscribe.isEnabled {
                                            self.performSegue(withIdentifier: "subscribeToTunnelSetup", sender: self)
                                        }
                                        
                                    case .notPurchased, .expired(_, _):
                                        defaults.setValue(false, forKey: hasUserPurchasedKey)
                                        let ac = UIAlertController(title: "Not Subscribed", message: "A valid subscription isn't associated with this Apple ID. Please try pressing the Restore button to check again.", preferredStyle: .alert)
                                        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                        self.present(ac, animated: true, completion: nil)
                                    }
                                case .error(error: let error):
                                    let ac = UIAlertController(title: "Error", message: "Something went wrong. Please try pressing the Restore button to check again. \(error.localizedDescription)", preferredStyle: .alert)
                                    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                    self.present(ac, animated: true, completion: nil)
                                }
                            }
                            
                        case .error(let error):
                            self.present(self.errorAlertController(type: error), animated: true, completion: nil)
                        }
                        
                    }
                }
            case .error(error: let error):
                let ac = UIAlertController(title: "Error", message: "Something went wrong. Please try again. \(error.localizedDescription)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(ac, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func btnRestore(_ sender: Any) {
        self.present(showLoadingIndicator(), animated: true, completion: nil)
        SwiftyStoreKit.verifyReceipt(using: AppleValidator) { (receiptResult) in
            self.dismiss(animated: true, completion: nil)
            switch receiptResult {
            case .success(receipt: let receipt):
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(ofType: .autoRenewable, productIds: Set(Subscriptions), inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased( _, _):
                    self.performSegue(withIdentifier: "subscribeToTunnelSetup", sender: self)
                case .expired( _, _):
                    if self.outSubscribe.isEnabled {
                        let ac = UIAlertController(title: "Subscription Expired", message: "Your subscription has expired. Please resubcribe to contniue.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(ac, animated: true, completion: nil)
                    }
                case .notPurchased:
                    let ac = UIAlertController(title: "Not Subscribed", message: "A valid subscription isn't associated with this Apple ID. Please try pressing the Restore button to check again.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(ac, animated: true, completion: nil)
                }
            case .error(error: let error):
                let ac = UIAlertController(title: "Error", message: "Something went wrong. Please try pressing the Restore button to check again. \(error.localizedDescription)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(ac, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btnLegal(_ sender: Any) {
        let popup = UIAlertController(title: "Legal", message: "A purchase will be applied to your Apple account upon the completion of the 3-day free trial. Subscriptions will automatically renew unless canceled within 24-hours before the end of the current period. You can cancel anytime in your Apple account settings. Any unused portion of a free trial will be forfeited if you purchase a subscription. For more information, see our Terms and Conditions and Privacy Policy.", preferredStyle: .actionSheet)
        
        let terms = UIAlertAction(title: "Terms & Conditions", style: .default) { (action) in
            if let url = URL(string: "https://info.tulabyte.com/terms-and-conditions") {
                UIApplication.shared.open(url)
            }
        }
        
        let privacy = UIAlertAction(title: "Privacy Policy", style: .default) { (action) in
            if let url = URL(string: "https://info.tulabyte.com/privacy-policy") {
                UIApplication.shared.open(url)
            }
        }
        
        let support = UIAlertAction(title: "Support", style: .default) { _ in
            UIApplication.shared.open(URL(string: "https://tulabyte.com/#support")!)
        }
        
        popup.addAction(terms)
        popup.addAction(privacy)
        popup.addAction(support)
        popup.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        popup.popoverPresentationController?.sourceRect = btnInfo.bounds
        popup.popoverPresentationController?.sourceView = btnInfo
        
        present(popup, animated: true, completion: nil)
    }
    
    //functions
    func errorAlertController(type: SKError) -> UIAlertController {
        var info: (title: String, message: String)!
        
        switch type.code {
        case .paymentCancelled:
            info = ("Payment Cancelled", "You cancelled the payment. Please try again.")
        case .paymentInvalid:
            info = ("Invalid Product", "This product appears invalid. Please contact support and try again")
        case .paymentNotAllowed:
            info = ("Payment Not Allowed", "You aren't allowed to make a payment from this device, please try again")
        default:
            info = ("Error", "Something went wrong. Please try again. \(type)")
        }
        
        let ac = UIAlertController(title: info.title, message: info.message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        return ac
    }
}

