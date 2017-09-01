//
//  ResetPasswordViewController.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 8/31/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    fileprivate struct Constant {
        struct Style {
            static let defaultBottomButtonConstraintConstrant: CGFloat = 20.0
        }
        struct TextLiteral {
            static let blankTextFieldErrorTitle = "Unset data"
            static let blankTextFieldErrorMessage = "You have to fill email textfield to reset your password!"
            
            static let serverErrorTitle = "Server error"
            static let serverErrorMessage = "Unexpected error occured! Please, try again."
            
            static let suggestionTitle = "Suggestions"
        }
    }

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
    override var defaultBottomButtonConstraintConstant: CGFloat {
        return Constant.Style.defaultBottomButtonConstraintConstrant
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
            displayAlertOnView(title: Constant.TextLiteral.blankTextFieldErrorTitle, text: Constant.TextLiteral.blankTextFieldErrorMessage)
            return
        }
        
        emailTextField.resignFirstResponder()
        addActivityIndicatorOnView()
        resetProgressIndicator?.startAnimating()
        
        LoginModel.resetPassword(email: emailTextField.text!) { [weak self] (suggestions, error) in
            self?.resetProgressIndicator?.stopAnimating()
            self?.resetProgressIndicator?.removeFromSuperview()
            
            if let suggestions = suggestions {
                self?.displayAlertOnView(title: Constant.TextLiteral.suggestionTitle, text: suggestions) {
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
