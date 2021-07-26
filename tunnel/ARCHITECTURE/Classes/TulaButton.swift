//
//  TulaButton.swift
//  tunnel
//
//  Created by Arjun Singh on 1/4/21.
//

import UIKit

class TulaButton: UIButton {

    @IBInspectable var borderWidth: CGFloat = 5
    @IBInspectable var borderColor: UIColor = UIColor(named: "TulabyteGreen")!
    @IBInspectable var cornerRadius: CGFloat = 15
    
    private let border = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateButton), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateButton), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func updateButton() {
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        //border
        border.lineWidth = borderWidth
        border.frame = self.bounds
        border.fillColor = nil
        border.strokeColor = borderColor.cgColor
        border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        self.layer.addSublayer(border)
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    
        if self.isEnabled {
            border.strokeColor = borderColor.cgColor
            self.setTitleColor(UIColor.white, for: .normal)
            self.backgroundColor = UIColor(named: "TulabyteActiveButton")
        } else {
            border.strokeColor = UIColor.clear.cgColor
            self.setTitleColor(UIColor.lightGray, for: .disabled)
            self.backgroundColor = UIColor(named: "TulabyteInactiveButton")
        }
    }
}

