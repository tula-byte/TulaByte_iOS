//
//  TulaSC.swift
//  tunnel
//
//  Created by Arjun Singh on 6/4/21.
//

import UIKit

class TulaSC: UISegmentedControl {

   
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        selectedSegmentTintColor = UIColor.init(white: 1, alpha: 0.4)
        backgroundColor = UIColor.init(white: 1, alpha: 0.1)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        
    }

}
