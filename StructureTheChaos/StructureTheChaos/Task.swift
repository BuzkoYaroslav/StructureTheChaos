//
//  Task.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 9/10/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import Foundation

class Task: NSObject {
    weak var day: Day?
    
    var title: String!
    var text: String?
    
    var timeRange: Range<Date>!
    var tags: [String]!
    var attachments: [Attachment]!
    
    init(day: Day, title: String, text: String? = nil, startDate: Date, endDate: Date, tags: [String]? = nil, attachments: [Attachment]? = nil) {
        super.init()
        
        self.title = title
        self.text = text
        self.timeRange = Range(uncheckedBounds: (startDate, endDate))
        self.tags = tags
        self.attachments = attachments
    }
}

