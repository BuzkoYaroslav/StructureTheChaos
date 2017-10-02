//
//  RegistrationViewController.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 8/31/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: LightTextField!
    @IBOutlet weak var loginTextField: LightTextField!
    @IBOutlet weak var passwordTextField: LightTextField!
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    weak var registrationProgressIndicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()

        setNeedsStatusBarAppearanceUpdate()
        configureTextFields()
        emailTextField.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
        startListenKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopListenKeyboardNotifications()
    }
    
    @IBAction func registrationButtonTapped(sender: UIButton) {
        register()
    }
}

// MARK: - initial state
extension RegistrationViewController {
    func configureTextFields() {
        emailTextField.delegate = self
        loginTextField.delegate = self
        passwordTextField.delegate = self
    }
    func configureNavigationBar() {
        navigationController?.navigationBar.setColor(Utils.Style.Color.navigationItemBackgroundColor)
        navigationController?.navigationBar.configureNavigationBarTitle(color: Utils.Style.Color.navigationItemTitleColor, font: Utils.Style.Font.navigationItemTitleFont)
    }
}

// MARK: - keyboard appearance
extension RegistrationViewController {
    override var bottomConstraint: NSLayoutConstraint! {
        return bottomButtonConstraint
    }
    override var defaultBottomConstraintConstant: CGFloat {
        return Utils.Style.Number.defaultBottomButtonConstraintConstant
    }
}

// MARK: - UITextFieldDelegate 
extension RegistrationViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var result = true
        
        switch textField {
        case emailTextField:
            result = switchTextFields(from: emailTextField, to: loginTextField)
        case loginTextField:
            result = switchTextFields(from: loginTextField, to: passwordTextField)
        case passwordTextField:
            if (passwordTextField.text == "") {
                result = false
            }
        default:
            break
        }
        
        return result
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        var result = true
        
        switch textField {
        case emailTextField where emailTextField.text == "":
            result = false
        case loginTextField where loginTextField.text == "":
            result = false
        case passwordTextField where passwordTextField.text == "":
            result = false
        default:
            break
        }
        
        return result

    }
    
    func switchTextFields(from textField1: UITextField, to textField2: UITextField) -> Bool {
        if (textField1.text == "") {
            return false
        }
        textField1.resignFirstResponder()
        textField2.becomeFirstResponder()
        return true
    }
}

// MARK: - registration
extension RegistrationViewController {
    func addActivityIndicatorOnView() {
        let indicator = activityInicator()
        navigationController?.view.addSubview(indicator)
        
        registrationProgressIndicator = indicator
    }
    
    func register() {
        guard (emailTextField.text != "" &&
               loginTextField.text != "" &&
            passwordTextField.text != "") else {
                displayAlertOnView(title: Utils.TextLiteral.ClientError.blankTextFieldErrorTitle, text: Utils.TextLiteral.ClientError.blankTextFieldErrorMessage)
                return
        }
        
        resignFirstResponders()
        addActivityIndicatorOnView()
        registrationProgressIndicator?.startAnimating()
        
        LoginModel.register(email: emailTextField.text!, login: loginTextField.text!, password: passwordTextField.text!) { [weak self] (suggestions, error) in
            self?.registrationProgressIndicator?.stopAnimating()
            self?.registrationProgressIndicator?.removeFromSuperview()
            
            if let suggestions = suggestions {
                self?.displayAlertOnView(title: Utils.TextLiteral.SuccessfulOperation.successfulRegistrationTitle, text: suggestions, alertHandler: {
                    self?.navigationController?.popViewController(animated: true)
                })
            } else if let error = error {
                self?.displayAlertOnView(title: error.title, text: error.message)
                
                switch error.type {
                case .incorrectMailFormat:
                    self?.emailTextField.becomeFirstResponder()
                case .incorrectLoginFormat:
                    self?.loginTextField.becomeFirstResponder()
                case .incorrectPasswordFormat:
                    self?.passwordTextField.becomeFirstResponder()
                default:
                    break
                }
            }
        }
    }
    
    func resignFirstResponders() {
        emailTextField.resignFirstResponder()
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
