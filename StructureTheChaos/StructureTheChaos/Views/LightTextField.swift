//
//  LightTextField.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 8/30/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import UIKit

@IBDesignable
class LightTextField: UITextField {

    // MARK: - inspectable properties
    // color of bottom line of border
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            setupBorder()
        }
    }
    
    // width of bottom line of border
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            setupBorder()
        }
    }
    
    // color of placeholder text
    @IBInspectable var placeHolderColor: UIColor = UIColor.white {
        didSet {
            setupPlaceHolder()
        }
    }
    
    // label that moving up when textfield text is changed from nil (begin editing)
    fileprivate var placeholderLabel: UILabel?
    
    override var placeholder: String? {
        didSet {
            setupPlaceHolder()
        }
    }
    
    // old border layer, used to store latest border of textfield
    fileprivate var oldLayer: CALayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupBorder()
        //delegate = self
        setupNotifications()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupBorder()
        //delegate = self
        setupNotifications()
    }
    
    deinit {
        removeNotifications()
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
}

// MARK: - managing UI when properties changed 
extension LightTextField {
    
    func setupBorder() {
        borderStyle = .none
        
        let border = CALayer()
        border.borderWidth = borderWidth
        border.borderColor = borderColor.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        oldLayer?.removeFromSuperlayer()
        oldLayer = border
        
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
    func setupPlaceHolder() {
        if let placeholder = placeholder {
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: placeHolderColor])
        }
    }

}

// MARK: - placeholder animation
extension LightTextField {

    func animatePlaceholderAppearance() {
        guard let placeholderLabel = placeholderLabel else {
            return
        }
        
        let yShiftLength = placeholderLabel.frame.size.height
        
        UIView.animate(withDuration: Utils.Animation.placeholderAppearanceTextFieldAnimationDuration) {
            placeholderLabel.center = CGPoint(x: placeholderLabel.center.x, y: placeholderLabel.center.y - yShiftLength)
            placeholderLabel.font = Utils.Style.Font.appearedTextFieldPlaceholderFont
        }
    }
    func animatePlaceholderHiddence(completion: @escaping () -> Void) {
        guard let placeholderLabel = placeholderLabel else {
            return
        }
        
        UIView.animate(withDuration: Utils.Animation.placeholderAppearanceTextFieldAnimationDuration, animations: {
            placeholderLabel.center = CGPoint(x: placeholderLabel.center.x, y: placeholderLabel.center.y + (self.frame.origin.y - placeholderLabel.frame.origin.y))
            placeholderLabel.font = Utils.Style.Font.notAppearedTextFieldPlaceholderFont
        }) { (finished) in
            if (finished) {
                completion()
            }
        }

    }
    
}

// MARK: - UITextFieldDidEndEditingNotification UITextFieldDidBeginEditingNotification
extension LightTextField {

    func textFieldDidChange(notification: NSNotification) {
        guard let textField = notification.object as? LightTextField,
              textField === self else {
            return
        }
        
        if (text == "" && placeholderLabel != nil) {
            animatePlaceholderHiddence { [weak self] () in
                self?.placeholder = self?.placeholderLabel?.text
                self?.placeholderLabel?.removeFromSuperview()
                self?.placeholderLabel = nil
            }
        }
        
        if (text == "" || placeholderLabel != nil) {
            return
        }
        
        guard let placeholderText = placeholder ?? attributedPlaceholder?.string else {
            return
        }
        placeholderLabel = createPlaceholderLabel(text: placeholderText)
        self.superview?.addSubview(placeholderLabel!)
        placeholder = ""
        
        animatePlaceholderAppearance()
    }
    
    func createPlaceholderLabel(text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: frame.origin.x + alignmentRectInsets.left, y: frame.origin.y + alignmentRectInsets.top, width: 1.0, height: 1.0))
        let font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightLight)
        label.font = font
        label.text = text
        label.textColor = placeHolderColor
        label.sizeToFit()
        
        return label
    }
    
}
