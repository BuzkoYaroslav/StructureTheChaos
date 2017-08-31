//
//  LightButton.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 8/30/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class LightButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var textColor: UIColor = UIColor.black {
        didSet {
            setTitleColor(textColor, for: .normal)
            layer.borderColor = textColor.cgColor
        }
    }// borderColor always is the same
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
        setup()
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    func setup() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
        setTitleColor(textColor, for: .normal)
        layer.borderColor = textColor.cgColor
        layer.borderWidth = borderWidth
    }
    
}
