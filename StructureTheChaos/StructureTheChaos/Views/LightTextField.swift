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
    
    struct LightTextFieldConstants {
        static let incorrectMailFormatMessage = "Incorrect mail format!" +
            "E-mail must only contain 2 group of characters (a-z,A-Z,0-9,.,-,_)" +
            "separated by @ sign"
        static let incorrectPasswordFormatMessage = "Incorrect password format!" +
            "Password must be at least 6 characters long and must contain only a-z,A-Z,0-9!"
        static let incorrectLoginFormatMessage = "Incorrect login format!" +
            "Login must be at least 4 characters long and must contain only a-z,A-Z!"
        
        static let validationErrorAlertTitle = "Validation error"
        static let validationErrorAlertButtonText = "OK"
    }

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
    
    // MARK: - delegate managging (i.e. recieve messages within class and outside in the mainDelegate
//    override var delegate: UITextFieldDelegate? {
//        get {
//            return mainDelegate
//        }
//        set {
//            if (newValue !== self) {
//                mainDelegate = newValue
//            } else {
//                super.delegate = self
//            }
//        }
//    }
//    fileprivate var mainDelegate: UITextFieldDelegate?
    
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
        
        UIView.animate(withDuration: 0.25) {
            placeholderLabel.center = CGPoint(x: placeholderLabel.center.x, y: placeholderLabel.center.y - yShiftLength)
            placeholderLabel.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightLight)
        }
    }
    func animatePlaceholderHiddence(completion: @escaping () -> Void) {
        guard let placeholderLabel = placeholderLabel else {
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            
        }
        
        UIView.animate(withDuration: 0.25, animations: { 
            placeholderLabel.center = CGPoint(x: placeholderLabel.center.x, y: placeholderLabel.center.y + (self.frame.origin.y - placeholderLabel.frame.origin.y))
            placeholderLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightLight)
        }) { (finished) in
            if (finished) {
                completion()
            }
        }

    }
    
}

// MARK: - validating content according to type
fileprivate extension LightTextField {
    

    func displayAlertAboutValidationError() {

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
