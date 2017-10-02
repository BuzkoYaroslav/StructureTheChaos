//
//  Validation.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 9/10/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import Foundation

enum DataType: Int {
    case login = 0
    case password
    case email
}

class Validation {
    static func validate(text: String, type: DataType) -> Bool {
        let expression = expressionForDataType(type)
        let range = NSRange(location: 0, length: text.characters.count)
        
        let matches = expression.matches(in: text, options: [], range: range)
        
        return matches.count == 1 &&
            matches[0].range.length == text.characters.count
    }
}

// MARK: - appropriate regex for type
extension Validation {
    
    fileprivate static func expressionForDataType(_ type: DataType) -> NSRegularExpression {
        switch type {
        case .login:
            return RegularExpression.login
        case .password:
            return RegularExpression.password
        case .email:
            return RegularExpression.email
        }
    }
    
}
