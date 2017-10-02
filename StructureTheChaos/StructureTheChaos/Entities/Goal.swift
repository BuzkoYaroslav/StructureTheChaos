//
//  Goal.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 9/10/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import Foundation

protocol GoalSettable: NSObjectProtocol {
    func addNewGoal(description: String, completion: (Error?) -> Void)
    func removeGoal(goal: Goal) -> Bool
    func getGoal(at index: Int) -> Goal?
    var goalsCount: Int { get }
}

enum GoalState {
    case inProgress
    case canceled
    case done
}

class Goal: NSObject {
    weak var setter: GoalSettable?
    
    var text: String!
    var state: GoalState!
    
    init(setter: GoalSettable, text: String) {
        super.init()
        
        self.setter = setter
        self.text = text
        
        state = .inProgress
    }
}
