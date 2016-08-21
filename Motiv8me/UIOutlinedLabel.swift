//
//  UIOutlinedLabel.swift
//  Motiv8me
//
//  Created by Ted Presley on 8/20/16.
//  Copyright © 2016 Ted Presley. All rights reserved.
//

import Foundation

import UIKit

class UIOutlinedLabel: UILabel {
    
    var outlineWidth: CGFloat = 4
    var outlineColor: UIColor = UIColor.blackColor()
    
    override func drawTextInRect(rect: CGRect) {
        
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : outlineColor,
            NSStrokeWidthAttributeName : -1 * outlineWidth,
            ]
        
        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
        super.drawTextInRect(rect)
    }
}