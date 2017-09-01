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
        struct TextLiteral {
            static let blankTextFieldErrorTitle = "Empty textfield"
            static let blankTextFieldErrorMessage = "You have to fill all of the textfields to login"
            
            static let serverErrorTitle = "Server error"
            static let serverErrorMessage = "Unexpected server error! Please, try again."
        }
    }
    
    @IBOutlet weak var passwordTextField: LightTextField!
    @IBOutlet weak var loginTextField: LightTextField!
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!
    
    weak var loginProgressIndicator: UIActivityIndicatorView?
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        loginProgressIndicator?.removeFromSuperview()
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
        var result = true
        
        switch textField {
        case loginTextField:
            if (loginTextField.text == "") {
                result = false
            }
            else {
                passwordTextField.becomeFirstResponder()
            }
        default:
            if (passwordTextField.text == "") {
                result = false
            }
            else {
                passwordTextField.resignFirstResponder()
                login()
            }
        }
        
        return result
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}

// MARK: - Logging in
extension LoginViewController {
    func login() {
        guard (loginTextField.text != "" && passwordTextField.text != "") else {
            displayAlertOnView(title: Constant.TextLiteral.blankTextFieldErrorTitle, text: Constant.TextLiteral.blankTextFieldErrorMessage)
            return
        }
        
        resignFirstResponsers()
        addActivityIndicatorOnView()
        loginProgressIndicator?.startAnimating()
        
        LoginModel.login(login: loginTextField.text!, password: passwordTextField.text!) { [weak self] (sessionId, error) in
            self?.loginProgressIndicator?.stopAnimating()
            
            if let sessionId = sessionId {
                
            } else if let error = error {
                self?.displayAlertOnView(title: error.title, text: error.message)
                
                switch error.type {
                case .incorrectLoginFormat:
                    self?.loginTextField.becomeFirstResponder()
                case .incorrectPasswordFormat:
                    self?.passwordTextField.becomeFirstResponder()
                default:
                    break
                }
            } else {
                self?.displayAlertOnView(title: Constant.TextLiteral.serverErrorTitle, text: Constant.TextLiteral.serverErrorMessage)
            }
        }
    }
    
    func addActivityIndicatorOnView() {
        let indicator = activityInicator()
        navigationController!.view.addSubview(indicator)
        loginProgressIndicator = indicator
    }
    
    func activityInicator() -> UIActivityIndicatorView {
        let ai = UIActivityIndicatorView(frame: self.navigationController!.view.bounds)
        ai.activityIndicatorViewStyle = .whiteLarge
        ai.backgroundColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 0.5)
        
        return ai
    }
    
    func resignFirstResponsers() {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
}
