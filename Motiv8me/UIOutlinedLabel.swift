//
//  UIOutlinedLabel.swift
//  Motiv8me
//
//

import Foundation

import UIKit

class UIOutlinedLabel: UILabel {
    
    var outlineWidth: CGFloat = 4
    var outlineColor: UIColor = UIColor.black
    
    override func drawText(in rect: CGRect) {
        
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : outlineColor,
            NSAttributedString.Key.strokeWidth : -1 * outlineWidth,
            ] as [NSAttributedString.Key : Any]
        
        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
        super.drawText(in: rect)
    }
}
