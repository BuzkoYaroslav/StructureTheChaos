//
//  ViewController.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 9/10/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GoalTableViewController,
            segue.identifier == "ShowVC" {
            vc.goalSetter = month()
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    func month() -> Month {
        //let user = User(user: LoginModel.currentUser()!)
        //let year = Year(user: user, number: 2017)
        let month = Month(year: nil, type: MonthType.July)
        
        var goals = [Goal]()
        month.goals = goals
        
        for index in 0..<5 {
            goals.append(Goal(setter: month, text: "\(index)"))
        }
        
        return month
    }
}
