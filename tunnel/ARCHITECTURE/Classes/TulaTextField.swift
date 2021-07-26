//
//  TulaTextField.swift
//  tunnel
//
//  Created by Arjun Singh on 6/4/21.
//

import UIKit

class TulaTextField: UITextField {

    @IBInspectable var image: UIImage? = nil
    @IBInspectable var leadPadding: CGFloat = 0
    @IBInspectable var spacing: CGFloat = 0
    
    private var textPadding: UIEdgeInsets {
        let pad: CGFloat = leadPadding + spacing + (leftView?.frame.width ?? 0)
        return UIEdgeInsets(top: 0, left: pad, bottom: 0, right: 5)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var r = super.leftViewRect(forBounds: bounds)
        r.origin.x += leadPadding
        return r
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        setup()
    }
    
    override func drawPlaceholder(in rect: CGRect) {
        super.drawPlaceholder(in: rect)
        textColor = UIColor.lightGray
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect)
        textColor = UIColor.white
    }

    private func setup(){
        if let image = image {
            if leftView != nil {return}
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            
            leftViewMode = UITextField.ViewMode.always
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
    }
}
