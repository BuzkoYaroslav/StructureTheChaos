//
//  File.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 9/10/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import Foundation
import FirebaseAuth


class User: NSObject {
    var user: FirebaseAuth.User!
    var years: [Int: Year]!
    
    init(user: FirebaseAuth.User) {
        super.init()
        
        self.user = user
        years = [:]
    }
}
