//
//  InterfaceUtilities.swift
//  tunnel
//
//  Created by Arjun Singh on 6/4/21.
//

import Foundation
import UIKit
import Network

//loading indicator view
func showLoadingIndicator() -> UIAlertController {
    let ac = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
    let loader = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    loader.hidesWhenStopped = true
    loader.style = .medium
    loader.startAnimating();
    
    ac.view.addSubview(loader)
    
    return ac
}

//create image extension
extension UIView {
    
    func createImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let image = renderer.image { (ctx) in
            layer.render(in: ctx.cgContext)
        }
        return image
    }
    
}

//array of directory items
var directoryItems: [DirectoryItem] = [
    DirectoryItem(title: "TulaByte Mobile App", description: "Our flagship product, the app you are currently in.", url: URL(string: "https://tulabyte.com")!, madeByUs: true),
    DirectoryItem(title: "DataReqests.org", description: "If you are a EU citizen, this website makes it extremely easy for you to enact your GDPR rights", url: URL(string: "https://www.datarequests.org")!)
]

//check network status
let nwConnectedKey = "NetworkConnected"
func setupNWMonitor() {
    nwmon.pathUpdateHandler = { path in
        if path.status == .satisfied {
            defaults.setValue(true, forKey: nwConnectedKey)
            NSLog("TB NW: Connected")
        } else if path.status == .unsatisfied {
            defaults.setValue(false, forKey: nwConnectedKey)
            NSLog("TB NW: Not Connected")
        }
    }
        
    let q = DispatchQueue(label: nwConnectedKey)
    
    nwmon.start(queue: q)
}
    
