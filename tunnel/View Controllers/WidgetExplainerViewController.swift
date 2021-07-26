//
//  WidgetExplainerViewController.swift
//  tunnel
//
//  Created by Arjun Singh on 30/3/21.
//

import UIKit

class WidgetExplainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let bgImg = UIImageView(frame: CGRect(x: 0, y: 0, width: outContainerView.bounds.width, height: outContainerView.bounds.width))
        bgImg.contentMode = .scaleAspectFit
        bgImg.image = UIImage(named: "WidgetPreview")
        
        outContainerView.addSubview(bgImg)
        
    }
    //outlets
    @IBOutlet weak var outContainerView: UIView!
    
    //actions
    @IBAction func btnContinue(_ sender: Any) {
        defaults.setValue(true, forKey: "completedOnboarding")
        performSegue(withIdentifier: "completedOnboarding", sender: self)
    }
}
