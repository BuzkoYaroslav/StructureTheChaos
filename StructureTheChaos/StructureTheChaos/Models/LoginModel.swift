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
        
    }
    
    static func validate(text: String, type: LoginDataType) -> Bool {      
        let expression = Constant.ValidationExpression.expressionForDataType(type)
        let range = NSRange(location: 0, length: text.characters.count)
        
        let matches = expression.matches(in: text, options: [], range: range)
        
        return matches.count == 1 &&
            matches[0].range.length == text.characters.count
    }
}
