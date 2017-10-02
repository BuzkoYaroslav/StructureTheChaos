//
//  Attachment.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 9/10/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import Foundation
import UIKit

class Attachment: NSObject {
    var thumnbailURL: String!
    var imageURL: String!
    
    var thumnbail: UIImage!
    var image: UIImage!
    
    init(thumnbailURL: String, imageURL: String) {
        super.init()
        
        self.thumnbailURL = thumnbailURL
        self.imageURL = imageURL
    }
}
