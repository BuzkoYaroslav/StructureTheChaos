//
//  Utils.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 9/10/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import Foundation
import UIKit

struct Utils {
    struct Style {
        struct Color {
            static let navigationItemBackgroundColor = UIColor(red: 1.0/255.0, green: 141.0/255.0, blue: 18.0/255.0, alpha: 1.0)
            static let navigationItemTitleColor = UIColor.white
        }
        struct Number {
            static let defaultBottomButtonConstraintConstant: CGFloat = 20.0
            
            static let doneStateCheckedViewMargin: CGFloat = 5.0
            static let canceledStateCheckedViewMargin: CGFloat = 5.0
        }
        struct Font {
            static let navigationItemTitleFont = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightLight)
            
            static let appearedTextFieldPlaceholderFont = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightLight)
            static let notAppearedTextFieldPlaceholderFont = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightLight)
        }
    }
    struct Animation {
        static let changeStateCheckedViewAnimationDuration = 0.25
        static let placeholderAppearanceTextFieldAnimationDuration = 0.25
    }
    
    struct TextLiteral {
        struct Style {
            static let goalViewControllerNavigationItemMonthText = "Monthly goals"
            static let goalViewControllerNavigationItemYearText = "Yearly goals"
            
        }
        
        struct ClientError {
            static let blankTextFieldErrorTitle = "Empty textfield"
            static let blankTextFieldErrorMessage = "You have to fill all of the textfields to login"
        }
        struct ServerError {
            static let serverErrorTitle = "Server error"
            static let serverErrorMessage = "Unexpected server error! Please, try again."
            
            static let serverResponseErrorTitle = "Server error"
            static let unverifiedEmailTitle = "Verification error"
            
            static let unverifiedEmailMessage = "You have not verified your account yet! Please, check email for verification letter and go to link in it to verify."
        }
        
        struct SuccessfulOperation {
            static let suggestionTitle = "Suggestions"
            static let successfulRegistrationTitle = "Successful registration"
            
            static let successfulResetEmailMessage = "Reset password instructions have been sent on your email."
            static let successfulRegistrationMessage = "Account has been successfully created! We have sent instructions on your email to verify the account. You can start using app after verification."
        }
        
        struct ValidationError {
            static let loginValidationErrorMessage = "Incorrect login format! " +
            "Login must be at least 4 characters long and must contain only whitespace,a-z,A-Z."
            static let passwordValidationErrorMessage = "Incorrect password format! " +
            "Password must be at least 6 characters long and must contain only a-z,A-Z,0-9."
            static let emailValidationErrorMessage = "Incorrect email format! " +
            "Email must have 2 groups of characters divided by @ sign. Characters must only be a-z,A-Z,0-9,.,_,-."
            
            static let loginValidationErrorTitle = "Incorrect login format"
            static let passwordValidationErrorTitle = "Incorrect password format"
            static let emailValidationErrorTitle = "Incorrect email format"
        }
    }
}
