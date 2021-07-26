//
//  TulaShareView.swift
//  tunnel
//
//  Created by Arjun Singh on 11/4/21.
//

import UIKit

class TulaShareView: UIView {

    @IBInspectable var borderWidth: CGFloat = 5
    @IBInspectable var borderColor: UIColor = UIColor(named: "TulabyteGreen")!
    @IBInspectable var cornerRadius: CGFloat = 15
    
    let border = CAShapeLayer()
    let gradient = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //setup border
        border.lineWidth = borderWidth
        border.frame = self.bounds
        border.fillColor = borderColor.cgColor
        border.strokeColor = borderColor.cgColor
        border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        self.layer.insertSublayer(border, at: 0)
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }

}
