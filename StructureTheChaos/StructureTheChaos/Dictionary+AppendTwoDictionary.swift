//
//  Dictionary+AppendTwoDictionary.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 8/30/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import Foundation

// MARK: - appending multiple dictionaries
extension Dictionary {
    static func append <K, V> (toDictionary dictionary: [K:V], newElements: [K:V]) -> [K: V]{
        var dict = dictionary
        for (k, v) in newElements {
            dict[k] = v
        }
        
        return dict
    }
}
