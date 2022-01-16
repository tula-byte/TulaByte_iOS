//
//  TunnelSetupViewController.swift
//  tunnel
//
//  Created by Arjun Singh on 30/3/21.
//

import UIKit

class TunnelSetupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
    }
    
    //outlets
    @IBOutlet weak var outToggleStackView: UIStackView!
    @IBOutlet weak var outSetupButton: TulaButton!
    @IBOutlet weak var outContinue: TulaButton!
    
    //actions
    @IBAction func btnInstall(_ sender: Any) {
        TunnelController.shared.enableTunnel(false, isUserExplicitToggle: true) { (error) in
            self.present(showLoadingIndicator(), animated: true, completion: nil)
            
            //setup lists for the first time
            setupTulaByteAllowList()
            setupTulaByteBlockList()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss(animated: true, completion: nil)
                let tunnelState = TunnelController.shared.tunnelStatus()
                
                if tunnelState != .invalid {
                    self.outSetupButton.setTitle("Setup Succesful!", for: .normal)
                    self.outSetupButton.backgroundColor = UIColor(named: "TulabyteGreen")
                    self.outContinue.isEnabled = true
                } else {
                    let ac = UIAlertController(title: "Setup not Successful", message: "TulaByte could not be setup properly. Please retry to allow TulaByte to function correctly.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
                    self.present(ac, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func btnContinue(_ sender: Any) {
            performSegue(withIdentifier: "setupToAudience", sender: self)
    }
    
    @IBAction func btnHowItWorks(_ sender: Any) {
        if let url = URL(string: "https://info.tulabyte.com/how-it-works"){
            UIApplication.shared.open(url)
        }
    }
    
}
