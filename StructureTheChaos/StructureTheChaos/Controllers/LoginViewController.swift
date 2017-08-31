//
//  LoginViewController.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 8/30/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    fileprivate struct Constant {
        struct Style {
            static let defaultBottomButtonConstraintConstant: CGFloat = 20.0
            static let navigationItemBackgroundColor = UIColor(red: 1.0/255.0, green: 141.0/255.0, blue: 18.0/255.0, alpha: 1.0)
            static let navigationItemTitleColor = UIColor.white
            static let navigationItemTitleFont = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightLight)
        }
    }
    
    @IBOutlet weak var passwordTextField: LightTextField!
    @IBOutlet weak var loginTextField: LightTextField!
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNeedsStatusBarAppearanceUpdate()
        configureTextFields()
        loginTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareInitialState()
        startListenKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopListenKeyboardNotifications()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        login()
    }
    

}

// MARK: - Initial confguration
extension LoginViewController {
    func configureTextFields() {
        loginTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func prepareInitialState() {
        navigationController?.navigationBar.setColor(Constant.Style.navigationItemBackgroundColor)
        navigationController?.navigationBar.configureNavigationBarTitle(color: Constant.Style.navigationItemTitleColor, font: Constant.Style.navigationItemTitleFont)
    }
}

// MARK: - properties required to manage keyboard appearance
extension LoginViewController {
    override var defaultBottomButtonConstraintConstant: CGFloat {
        return Constant.Style.defaultBottomButtonConstraintConstant
    }
    override var bottomConstraint: NSLayoutConstraint! {
        return bottomButtonConstraint
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
        // TODO: login
    }
    
}
