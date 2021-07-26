//
//  WelcomeViewController.swift
//  tunnel
//
//  Created by Arjun Singh on 30/3/21.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //hide nav bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        for sub in Subscriptions {
            addSubscriptionInfoToDefaults(id: sub)
        }
    
        }
    
    @IBAction func btnContinue(_ sender: Any) {
        //performSegue(withIdentifier: "toSub", sender: self)
        
        defaults.setValue(true, forKey: hasUserPurchasedKey)
        performSegue(withIdentifier: "toSub", sender: self)
    }
    
    }
