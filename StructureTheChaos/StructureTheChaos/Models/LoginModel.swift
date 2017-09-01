//
//  File.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 8/31/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import Foundation

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
                let regexPattern = "[a-z0-9]{4,}"
                
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
                "Login must be at least 4 characters long and must contain only a-z,A-Z."
            static let passwordValidationErrorMessage = "Incorrect password format! " +
                "Password must be at least 6 characters long and must contain only a-z,A-Z,0-9."
            static let emailValidationErrorMessage = "Incorrect email format! " +
                "Email must have 2 groups of characters divided by @ sign. Characters must only be a-z,A-Z,0-9,.,_,-."
            
            static let loginValidationErrorTitle = "Incorrect login format"
            static let passwordValidationErrorTitle = "Incorrect password format"
            static let emailValidationErrorTitle = "Incorrect email format"
        }
        
    }
    
    static func validate(text: String, type: LoginDataType) -> Bool {      
        let expression = Constant.ValidationExpression.expressionForDataType(type)
        let range = NSRange(location: 0, length: text.characters.count)
        
        let matches = expression.matches(in: text, options: [], range: range)
        
        return matches.count == 1 &&
            matches[0].range.length == text.characters.count
    }
    
    static func login(login: String, password: String, completion: (String?, LoginError?) -> Void) {
        guard (validate(text: login, type: .login)) else {
            completion(nil, LoginError(title: Constant.ValidationError.loginValidationErrorTitle, message: Constant.ValidationError.loginValidationErrorMessage, type: .incorrectLoginFormat))
            return
        }
        
        guard (validate(text: password, type: .password)) else {
            completion(nil, LoginError(title: Constant.ValidationError.passwordValidationErrorTitle, message: Constant.ValidationError.passwordValidationErrorMessage, type: .incorrectPasswordFormat))
            return
        }
        
    }
    
    static func resetPassword(email: String, completion: (String?, LoginError?) -> Void) {
        guard (validate(text: email, type: .email)) else {
            completion(nil, LoginError(title: Constant.ValidationError.emailValidationErrorTitle, message: Constant.ValidationError.emailValidationErrorMessage, type: .incorrectMailFormat))
            return
        }
        
    }
}
