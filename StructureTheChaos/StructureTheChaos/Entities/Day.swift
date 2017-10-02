//
//  Day.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 9/10/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import Foundation

class Day: NSObject {
    weak var month: Month?
    
    var number: Int!
    var tasks: [Task]!
    
    init(month: Month, number: Int) {
        super.init()
        
        self.month = month
        self.number = number
        
        tasks = []
    }
}
