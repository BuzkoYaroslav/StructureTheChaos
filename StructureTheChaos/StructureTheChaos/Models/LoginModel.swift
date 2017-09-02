//
//  File.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 8/31/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import Foundation
import FirebaseAuth

enum LoginDataType: Int {
    case login = 0
    case password
    case email
}

enum LoginErrorType {
    case incorrectMailFormat
    case incorrectLoginFormat
    case incorrectPasswordFormat
    
    case incorrectPassword
    case incorrectLogin
    
    case loginIsTaken
    case emailIsAlreadyRegistred
    
    case unregistredEmail
    case unverifiedEmail
}

struct LoginError {
    var title: String
    var message: String
    
    var type: LoginErrorType
}

class LoginModel {
    private struct Constant {
        struct ValidationExpression {
            static var password: NSRegularExpression {
                let regexPattern = "[a-z0-9]{6,}"
                
                return try! NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
            }
            static var email: NSRegularExpression {
                let regexPattern = "[a-z0-9._-]{2,}@[a-z-.]{2,}"
                
                return try! NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
            }
            static var login: NSRegularExpression {
                let regexPattern = "[a-z0-9 ]{4,}"
                
                return try! NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
            }
            
            static func expressionForDataType(_ type: LoginDataType) -> NSRegularExpression {
                switch type {
                case .login:
                    return login
                case .password:
                    return password
                case .email:
                    return email
                }
            }
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
        struct ServerError {
            static let serverResponseErrorTitle = "Server error"
            static let serverErrorTitle = "Login error"
            static let unverifiedEmailTitle = "Verification error"
            
            static let unverifiedEmailMessage = "You have not verified your account yet! Please, check email for verification letter and go to link in it to verify."
        }
        struct TextLiteral {
            static let successfulResetEmailMessage = "Reset password instructions have been sent on your email."
            static let successfulRegistrationMessage = "Account has been successfully created! We have sent instructions on your email to verify the account. You can start using app after verification."
        }
    }
    
    static func validate(text: String, type: LoginDataType) -> Bool {      
        let expression = Constant.ValidationExpression.expressionForDataType(type)
        let range = NSRange(location: 0, length: text.characters.count)
        
        let matches = expression.matches(in: text, options: [], range: range)
        
        return matches.count == 1 &&
            matches[0].range.length == text.characters.count
    }
    
    static func login(email: String, password: String, completion: @escaping (String?, LoginError?) -> Void) {
        guard (validate(text: email, type: .email)) else {
            completion(nil, LoginError(title: Constant.ValidationError.emailValidationErrorTitle, message: Constant.ValidationError.emailValidationErrorMessage, type: .incorrectMailFormat))
            return
        }
        
        guard (validate(text: password, type: .password)) else {
            completion(nil, LoginError(title: Constant.ValidationError.passwordValidationErrorTitle, message: Constant.ValidationError.passwordValidationErrorMessage, type: .incorrectPasswordFormat))
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                completion(nil, LoginError(title: Constant.ServerError.serverErrorTitle, message: error.localizedDescription, type: .incorrectPassword))
            } else if let user = user {
                if (!user.isEmailVerified) {
                    completion(nil, LoginError(title: Constant.ServerError.unverifiedEmailTitle, message: Constant.ServerError.unverifiedEmailMessage, type: .unverifiedEmail))
                    return
                }
                
                // TODO: send user or special key as a respond
                completion("Success", nil)
            } else {
                
            }
        }
    }
    
    static func resetPassword(email: String, completion: @escaping (String?, LoginError?) -> Void) {
        guard (validate(text: email, type: .email)) else {
            completion(nil, LoginError(title: Constant.ValidationError.emailValidationErrorTitle, message: Constant.ValidationError.emailValidationErrorMessage, type: .incorrectMailFormat))
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                completion(nil, LoginError(title: Constant.ServerError.serverResponseErrorTitle, message: error.localizedDescription, type: .unregistredEmail))
            } else {
                completion(Constant.TextLiteral.successfulResetEmailMessage, nil)
            }
        }
    }
    
    static func register(email: String, login: String, password: String, completion: @escaping (String?, LoginError?) -> Void) {
        guard (validate(text: email, type: .email)) else {
            completion(nil, LoginError(title: Constant.ValidationError.emailValidationErrorTitle, message: Constant.ValidationError.emailValidationErrorMessage, type: .incorrectMailFormat))
            return
        }
        guard (validate(text: login, type: .login)) else {
            completion(nil, LoginError(title: Constant.ValidationError.loginValidationErrorTitle, message: Constant.ValidationError.loginValidationErrorMessage, type: .incorrectLoginFormat))
            return
        }
        
        guard (validate(text: password, type: .password)) else {
            completion(nil, LoginError(title: Constant.ValidationError.passwordValidationErrorTitle, message: Constant.ValidationError.passwordValidationErrorMessage, type: .incorrectPasswordFormat))
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                completion(nil, LoginError(title: Constant.ServerError.serverResponseErrorTitle, message: error.localizedDescription, type: .unregistredEmail))
            } else if let user = user {
                let request = user.createProfileChangeRequest()
                request.displayName = login
                request.commitChanges(completion: { (error) in
                    if let error = error {
                        completion(nil, LoginError(title: Constant.ServerError.serverResponseErrorTitle, message: error.localizedDescription, type: .incorrectLogin)) // TODO: appropriate error type
                    } else {
                        completion(Constant.TextLiteral.successfulRegistrationMessage, nil)
                    }
                })
            }
        }
    }
}
