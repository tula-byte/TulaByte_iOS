//
//  TulaBlankTableViewExtension.swift
//  tunnel
//
//  Created by Arjun Singh on 21/6/21.
//

import Foundation
import UIKit



extension UITableView {
    ///solution based on https://stackoverflow.com/a/45157417
    
    func setEmptyTableView(message: String) {
        let width = self.bounds.size.width * 0.7
        let label = UILabel(frame: CGRect(x: ((self.bounds.size.width - width)/2), y: 0, width: width, height: self.bounds.size.height))
        label.text = message
        label.textColor = UIColor(red: 0.92, green: 0.92, blue: 0.96, alpha: 0.3)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica Neue Medium", size: 15.0)
        label.sizeToFit()
        
        self.backgroundView = label
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
}
