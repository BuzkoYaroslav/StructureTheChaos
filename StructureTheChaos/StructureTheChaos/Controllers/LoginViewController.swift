//
//  LoginViewController.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 8/30/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var passwordTextField: LightTextField!
    @IBOutlet weak var loginTextField: LightTextField!
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!
    
    let defaultBottomButtonConstraintConstant: CGFloat = 20.0
    let navigationItemBackgroundColor = UIColor(red: 1.0/255.0, green: 141.0/255.0, blue: 18.0/255.0, alpha: 1.0)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNeedsStatusBarAppearanceUpdate()
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareInitialState()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name:NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        login()
    }

}

// MARK: - Initial confguration
extension LoginViewController {
    func prepareInitialState() {
        navigationController?.navigationBar.setColor(navigationItemBackgroundColor)
        navigationController?.navigationBar.tintColor = UIColor.white
        var newAttributes: [String: Any] = [NSForegroundColorAttributeName: UIColor.white,
                                            NSFontAttributeName: UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightLight)]
        if let dictionaryAttributes = navigationController?.navigationBar.titleTextAttributes {
            newAttributes = Dictionary<String, Any>.append(toDictionary: dictionaryAttributes, newElements: newAttributes)
        }
        navigationController?.navigationBar.titleTextAttributes = newAttributes
    }
    func configureNavigationItem() {
        let font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightLight)
        let titleLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        titleLabel.text = navigationItem.title
        titleLabel.font = font
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }
}

// MARK: - manage keyboard appearance
extension LoginViewController {
    func keyboardDidShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        moveButton(pointsFromBottom: keyboardFrame.height + defaultBottomButtonConstraintConstant)
    }
    func keyboardDidHide(notification: NSNotification) {
        moveButton(pointsFromBottom: defaultBottomButtonConstraintConstant)
    }
    
    func moveButton(pointsFromBottom length: CGFloat) {
        bottomButtonConstraint.constant = length
        
        UIView.animate(withDuration: 1.0) { 
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextField:
            passwordTextField.becomeFirstResponder()
        default:
            passwordTextField.resignFirstResponder()
            
            login()
        }
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}

// MARK: - Logging in
extension LoginViewController {
    func login() {
        
    }
}
