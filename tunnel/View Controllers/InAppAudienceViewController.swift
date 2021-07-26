//
//  InAppAudienceViewController.swift
//  tunnel
//
//  Created by Arjun Singh on 11/4/21.
//

import UIKit

class InAppAudienceViewController: AudienceViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // actions
    @IBAction func btnBack(_ sender: Any) {
        dismissViewController()
    }
    
    @IBAction override func txtEmailReturnPressed(_ sender: Any) {
        super.txtEmailReturnPressed(self)
    }
    
    
    // functions
    override func displaySuccessAlert(type: Int) {
            var title = ""
            var message = ""
            
            switch type {
            case 0:
                title = "Subscribed Succesfully"
                message = "You were succesfully subscribed to the TulaByte newsletter."
            case 1:
                title = "Already Subscribed"
                message = "You are already subscribed to the newsletter!"
            default:
                break
            }
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) in
                self.dismissViewController()
            }))
            self.present(ac, animated: true, completion: nil)
    }
    
    func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}
