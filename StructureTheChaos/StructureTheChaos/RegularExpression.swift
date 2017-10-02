//
//  RegularExpression.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 9/10/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import Foundation

class RegularExpression {
    static var empty: NSRegularExpression {
        return NSRegularExpression()
    }
    
    static var password: NSRegularExpression {
        let regexPattern = "[a-z0-9]{6,}"
        
        do {
            return try NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
        } catch {
            return empty
        }
    }
    static var email: NSRegularExpression {
        let regexPattern = "[a-z0-9._-]{2,}@[a-z-.]{2,}"
        
        do {
            return try NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)

        } catch {
            return empty
        }
    }
    static var login: NSRegularExpression {
        let regexPattern = "[a-z0-9 ]{4,}"
        
        do {
            return try NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
        } catch {
            return empty
        }
        
    }
}
