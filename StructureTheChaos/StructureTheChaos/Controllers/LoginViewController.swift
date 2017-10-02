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
    @IBOutlet weak var emailTextField: LightTextField!
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!
    
    weak var loginProgressIndicator: UIActivityIndicatorView?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNeedsStatusBarAppearanceUpdate()
        configureTextFields()
        emailTextField.becomeFirstResponder()
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
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func prepareInitialState() {
        navigationController?.navigationBar.setColor(Utils.Style.Color.navigationItemBackgroundColor)
        navigationController?.navigationBar.configureNavigationBarTitle(color: Utils.Style.Color.navigationItemTitleColor, font: Utils.Style.Font.navigationItemTitleFont)
    }
}

// MARK: - properties required to manage keyboard appearance
extension LoginViewController {
    override var defaultBottomConstraintConstant: CGFloat {
        return Utils.Style.Number.defaultBottomButtonConstraintConstant
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
        case emailTextField:
            if (emailTextField.text == "") {
                result = false
            } else {
                passwordTextField.becomeFirstResponder()
            }
        default:
            if (passwordTextField.text == "") {
                result = false
            } else {
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
        guard (emailTextField.text != "" && passwordTextField.text != "") else {
            displayAlertOnView(title: Utils.TextLiteral.ClientError.blankTextFieldErrorTitle, text: Utils.TextLiteral.ClientError.blankTextFieldErrorMessage)
            return
        }
        
        resignFirstResponsers()
        addActivityIndicatorOnView()
        loginProgressIndicator?.startAnimating()
        
        LoginModel.login(email: emailTextField.text!, password: passwordTextField.text!) { [weak self] (userId, error) in
            self?.loginProgressIndicator?.stopAnimating()
            
            if let _ = userId {
                self?.navigateToPlanViewController()
            } else if let error = error {
                self?.displayAlertOnView(title: error.title, text: error.message)
                
                switch error.type {
                case .incorrectMailFormat:
                    self?.emailTextField.becomeFirstResponder()
                case .incorrectPasswordFormat:
                    self?.passwordTextField.becomeFirstResponder()
                default:
                    break
                }
            } else {
                self?.displayAlertOnView(title: Utils.TextLiteral.ServerError.serverErrorTitle, text: Utils.TextLiteral.ServerError.serverErrorMessage)
            }
        }
    }
    
    func addActivityIndicatorOnView() {
        let indicator = activityInicator()
        navigationController!.view.addSubview(indicator)
        loginProgressIndicator = indicator
    }
    
    func resignFirstResponsers() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func navigateToPlanViewController() {
        
    }
    
}
