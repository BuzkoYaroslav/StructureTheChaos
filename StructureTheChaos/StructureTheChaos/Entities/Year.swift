//
//  Year.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 9/10/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import Foundation

class Year: NSObject {
    weak var user: User!
    
    var number: Int!
    var months: [MonthType: Month]!
    var goals: [Goal]!
    
    init(user: User, number: Int) {
        super.init()
        
        self.user = user
        self.number = number
        
        months = [:]
        goals = []
    }
}

// MARK: - GoalSettable
// TODO: - appropriate collaboration with model
extension Year : GoalSettable {
    func addNewGoal(description: String, completion: (Error?) -> Void) {
        goals.append(Goal(setter: self, text: description))
        
        completion(nil)
    }
    func removeGoal(goal: Goal) -> Bool {
        guard let index = goals.index(where: { iterGoal in
            return goal === iterGoal
        }) else {
            return false
        }
        
        goals.remove(at: index)
        
        return true
    }
    func getGoal(at index: Int) -> Goal? {
        guard (index >= 0 && index < goalsCount) else {
            return nil
        }
        
        return goals[index]
    }
    
    var goalsCount: Int {
        return goals.count
    }
}
