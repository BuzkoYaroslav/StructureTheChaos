//
//  Month.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 9/10/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import Foundation

enum MonthType: String {
    case January = "January"
    case February = "February"
    case March = "March"
    case April = "April"
    case May = "May"
    case June = "June"
    case July = "July"
    case August = "August"
    case September = "September"
    case October = "October"
    case November = "November"
    case December = "December"
}

class Month: NSObject {
    weak var year: Year?
    
    var type: MonthType!
    var days: [Int: Day]!
    var goals: [Goal]!
    
    init(year: Year?, type: MonthType) {
        super.init()
        
        self.year = year
        self.type = type
        
        days = [:]
        goals = []
    }
}

// MARK: - GoalSettable 
// TODO: - appropriate collaboration with model
extension Month : GoalSettable {
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
