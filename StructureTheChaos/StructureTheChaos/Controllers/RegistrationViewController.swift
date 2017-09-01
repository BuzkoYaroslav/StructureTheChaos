//
//  RegistrationViewController.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 8/31/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    fileprivate struct Constant {
        struct Style {
            static let defaultBottomButtonConstraintConstant: CGFloat = 20.0
            static let navigationItemBackgroundColor = UIColor(red: 1.0/255.0, green: 141.0/255.0, blue: 18.0/255.0, alpha: 1.0)
            static let navigationItemTitleColor = UIColor.white
            static let navigationItemTitleFont = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightLight)
        }
        struct TextLiteral {
            static let blankTextFieldErrorTitle = "Unset data"
            static let blankTextFiledErrorMessage = "You have to fill all of the textfields to register!"
            
            static let serverErrorTitle = "Server error"
            static let serverErrorMessage = "Unexpected error occured! Please, try again."
            
            static let suggestionTitle = "Successful registration"
        }
    }
    
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
        navigationController?.navigationBar.setColor(Constant.Style.navigationItemBackgroundColor)
        navigationController?.navigationBar.configureNavigationBarTitle(color: Constant.Style.navigationItemTitleColor, font: Constant.Style.navigationItemTitleFont)
    }
}

// MARK: - keyboard appearance
extension RegistrationViewController {
    override var bottomConstraint: NSLayoutConstraint! {
        return bottomButtonConstraint
    }
    override var defaultBottomButtonConstraintConstant: CGFloat {
        return Constant.Style.defaultBottomButtonConstraintConstant
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
                displayAlertOnView(title: Constant.TextLiteral.blankTextFieldErrorTitle, text: Constant.TextLiteral.blankTextFiledErrorMessage)
                return
        }
        
        resignFirstResponders()
        addActivityIndicatorOnView()
        registrationProgressIndicator?.startAnimating()
        
        LoginModel.register(email: emailTextField.text!, login: loginTextField.text!, password: passwordTextField.text!) { [weak self] (suggestions, error) in
            self?.registrationProgressIndicator?.stopAnimating()
            self?.registrationProgressIndicator?.removeFromSuperview()
            
            if let suggestions = suggestions {
                self?.displayAlertOnView(title: Constant.TextLiteral.suggestionTitle, text: suggestions, alertHandler: { 
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
