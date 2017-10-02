//
//  File.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 8/31/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import Foundation
import FirebaseAuth


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
    
    case serverError
}

struct LoginError {
    var title: String
    var message: String
    
    var type: LoginErrorType
}

class LoginModel {
    static func login(email: String, password: String, completion: @escaping (String?, LoginError?) -> Void) {
        guard (Validation.validate(text: email, type: .email)) else {
            completion(nil, LoginError(title: Utils.TextLiteral.ValidationError.emailValidationErrorTitle, message: Utils.TextLiteral.ValidationError.emailValidationErrorMessage, type: .incorrectMailFormat))
            return
        }
        
        guard (Validation.validate(text: password, type: .password)) else {
            completion(nil, LoginError(title: Utils.TextLiteral.ValidationError.passwordValidationErrorTitle, message: Utils.TextLiteral.ValidationError.passwordValidationErrorMessage, type: .incorrectPasswordFormat))
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                completion(nil, LoginError(title: Utils.TextLiteral.ServerError.serverErrorTitle, message: error.localizedDescription, type: .incorrectPassword))
            } else if let user = user {
                if (!user.isEmailVerified) {
                    completion(nil, LoginError(title: Utils.TextLiteral.ServerError.unverifiedEmailTitle, message: Utils.TextLiteral.ServerError.unverifiedEmailMessage, type: .unverifiedEmail))
                    return
                }
                
                completion(user.uid, nil)
            } else {
                completion(nil, LoginError(title: Utils.TextLiteral.ServerError.serverErrorTitle, message: Utils.TextLiteral.ServerError.serverErrorMessage, type: .serverError))
            }
        }
    }
    
    static func resetPassword(email: String, completion: @escaping (String?, LoginError?) -> Void) {
        guard (Validation.validate(text: email, type: .email)) else {
            completion(nil, LoginError(title: Utils.TextLiteral.ValidationError.emailValidationErrorTitle, message: Utils.TextLiteral.ValidationError.emailValidationErrorMessage, type: .incorrectMailFormat))
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                completion(nil, LoginError(title: Utils.TextLiteral.ServerError.serverResponseErrorTitle, message: error.localizedDescription, type: .unregistredEmail))
            } else {
                completion(Utils.TextLiteral.SuccessfulOperation.successfulResetEmailMessage, nil)
            }
        }
    }
    
    static func register(email: String, login: String, password: String, completion: @escaping (String?, LoginError?) -> Void) {
        guard (Validation.validate(text: email, type: .email)) else {
            completion(nil, LoginError(title: Utils.TextLiteral.ValidationError.emailValidationErrorTitle, message: Utils.TextLiteral.ValidationError.emailValidationErrorMessage, type: .incorrectMailFormat))
            return
        }
        guard (Validation.validate(text: login, type: .login)) else {
            completion(nil, LoginError(title: Utils.TextLiteral.ValidationError.loginValidationErrorTitle, message: Utils.TextLiteral.ValidationError.loginValidationErrorMessage, type: .incorrectLoginFormat))
            return
        }
        
        guard (Validation.validate(text: password, type: .password)) else {
            completion(nil, LoginError(title: Utils.TextLiteral.ValidationError.passwordValidationErrorTitle, message: Utils.TextLiteral.ValidationError.passwordValidationErrorMessage, type: .incorrectPasswordFormat))
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                completion(nil, LoginError(title: Utils.TextLiteral.ServerError.serverResponseErrorTitle, message: error.localizedDescription, type: .unregistredEmail))
            } else if let user = user {
                let request = user.createProfileChangeRequest()
                request.displayName = login
                request.commitChanges(completion: { (error) in
                    if let error = error {
                        completion(nil, LoginError(title: Utils.TextLiteral.ServerError.serverResponseErrorTitle, message: error.localizedDescription, type: .serverError)) // TODO: appropriate error type
                    } else {
                        completion(Utils.TextLiteral.SuccessfulOperation.successfulRegistrationMessage, nil)
                        Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                    }
                })
            }
        }
    }
    
    static func currentUser() -> FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
    
    static var isAuthorized: Bool {
        let user = currentUser()
        
        return user != nil && user!.isEmailVerified
    }
}


