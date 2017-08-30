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

    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            setupBorder()
        }
    }
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            setupBorder()
        }
    }
    @IBInspectable var placeHolderColor: UIColor = UIColor.white {
        didSet {
            setupPlaceHolder()
        }
    }
    override var placeholder: String? {
        didSet {
            setupPlaceHolder()
        }
    }
    
    private var oldLayer: CALayer?
    
    override var delegate: UITextFieldDelegate? {
        didSet {
            if (delegate !== self) {
                mainDelegate = delegate
                delegate = self
            }
        }
    }
    var mainDelegate: UITextFieldDelegate?
    
    var placeholderLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBorder()
        
        inputDelegate = self
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupBorder()
        
        inputDelegate = self
    }
    
    
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
        
    }
    func animatePlaceholderHiddence() {
        
    }
    
}
// MARK: - UITextInputDelegate 
extension LightTextField: UITextInputDelegate {
    func textDidChange(_ textInput: UITextInput?) {
        if (placeholderLabel == nil && textInput?.hasText ?? false) {
            animatePlaceholderAppearance()
        }
    }
    func textWillChange(_ textInput: UITextInput?) {
        
    }
    public func selectionWillChange(_ textInput: UITextInput?){}
    
    public func selectionDidChange(_ textInput: UITextInput?){}
}

// MARK: - UITextFieldDelegate
extension LightTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let result = mainDelegate?.textFieldShouldReturn?(textField) ?? true
        
        return result
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let result = mainDelegate?.textFieldShouldBeginEditing?(textField) ?? true
        
        if (textField.text == nil) {
            animatePlaceholderAppearance()
        }
        
        return result
    }
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let result = mainDelegate?.textFieldShouldEndEditing?(textField) ?? true
        
        
        return result
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = mainDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
        
        
        return result
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        mainDelegate?.textFieldDidEndEditing?(textField)
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        mainDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let result = mainDelegate?.textFieldShouldClear?(textField) ?? true
        
        return result
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        mainDelegate?.textFieldDidEndEditing?(textField, reason: reason)
    }

}
