//
//  UIViewController+KeyboardAppearance.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 8/31/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import UIKit

// MARK: - manage keyboard appearance
extension UIViewController {
    var defaultBottomButtonConstraintConstant: CGFloat {
        return 0;
    }
    var bottomConstraint: NSLayoutConstraint! {
        return nil
    }
    
    func startListenKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name:NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    func stopListenKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        moveButton(pointsFromBottom: keyboardFrame.height + defaultBottomButtonConstraintConstant)
    }
    func keyboardDidHide(notification: NSNotification) {
        moveButton(pointsFromBottom: defaultBottomButtonConstraintConstant)
    }
    
    func moveButton(pointsFromBottom length: CGFloat) {
        bottomConstraint.constant = length
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
}


