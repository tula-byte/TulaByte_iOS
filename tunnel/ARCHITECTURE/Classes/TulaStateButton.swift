//
//  TulaStateButton.swift
//  tunnel
//
//  Created by Arjun Singh on 4/4/21.
//

import UIKit

class TulaStateButton: UIButton {

    @IBInspectable var borderWidth: CGFloat = 5
    @IBInspectable var colour: UIColor = UIColor(named: "TulabyteGreen")!
    @IBInspectable var cornerRadius: CGFloat = 15
    
    @IBInspectable var isActive:Bool = false
    
    private let border = CAShapeLayer()
    private let bg = CAShapeLayer()
    
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
        border.strokeColor = colour.cgColor
        border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        self.layer.addSublayer(border)
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        
        //bg
        bg.frame = self.bounds
        bg.fillColor = nil
        bg.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        self.layer.insertSublayer(bg, at: 0)
        
        if isActive {
            setSelected()
        } else {
            setDeselected()
        }
        
        // Add a listener for button presses -> calls onPress() objc function
        self.addTarget(self, action: #selector(onPress), for: .touchUpInside)
    }
    
    @objc func onPress(){
        // Toggle active
        isActive = !isActive
        
        // Perform changing logic
        if isActive {
            setSelected()
        } else {
            setDeselected()
        }
    }
    
    func setSelected(){
        bg.fillColor = colour.cgColor
    }
    
    func setDeselected(){
        bg.fillColor = UIColor.clear.cgColor
    }

}
