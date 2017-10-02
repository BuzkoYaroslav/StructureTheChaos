//
//  ResetPasswordViewController.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 8/31/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: LightTextField!
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    weak var resetProgressIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNeedsStatusBarAppearanceUpdate()
        emailTextField.delegate = self
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startListenKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopListenKeyboardNotifications()
    }
    
    @IBAction func resetPasswordButtonTapped(sender: UIButton) {
        resetPassword()
    }

}

// MARK: - managing keyboard appearance
extension ResetPasswordViewController {
    override var defaultBottomConstraintConstant: CGFloat {
        return Utils.Style.Number.defaultBottomButtonConstraintConstant
    }
    override var bottomConstraint: NSLayoutConstraint! {
        return bottomButtonConstraint
    }
}

// MARK: - UITextFieldDelegate 
extension ResetPasswordViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text == "") {
            return false
        }
        
        resetPassword()
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField.text == "") {
            return false
        }
        
        return true
    }
}

// MARK: - resetting password
extension ResetPasswordViewController {
    func addActivityIndicatorOnView() {
        let indicator = activityInicator()
        navigationController?.view.addSubview(indicator)
        
        resetProgressIndicator = indicator
    }
    func resetPassword() {
        guard (emailTextField.text != "") else {
            displayAlertOnView(title: Utils.TextLiteral.ClientError.blankTextFieldErrorTitle, text: Utils.TextLiteral.ClientError.blankTextFieldErrorMessage)
            return
        }
        
        emailTextField.resignFirstResponder()
        addActivityIndicatorOnView()
        resetProgressIndicator?.startAnimating()
        
        LoginModel.resetPassword(email: emailTextField.text!) { [weak self] (suggestions, error) in
            self?.resetProgressIndicator?.stopAnimating()
            self?.resetProgressIndicator?.removeFromSuperview()
            
            if let suggestions = suggestions {
                self?.displayAlertOnView(title: Utils.TextLiteral.SuccessfulOperation.suggestionTitle, text: suggestions) {
                    self?.navigationController?.popViewController(animated: true)
                }
            } else if let error = error {
                self?.displayAlertOnView(title: error.title, text: error.message)
                
                if (error.type == .incorrectMailFormat) {
                    self?.emailTextField.becomeFirstResponder()
                }
            }
        }
    }
}
