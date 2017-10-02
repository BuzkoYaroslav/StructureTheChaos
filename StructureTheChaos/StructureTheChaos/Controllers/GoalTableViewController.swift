//
//  GoalTableViewController.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 9/10/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import UIKit

enum GoalType {
    case month
    case year
}

class GoalTableViewController: UITableViewController {
    struct Constant {
        struct CellIdentifier {
            static let noGoalCell = "NoGoalStaticTableViewCell"
            static let addNewGoalCell = "AddNewGoalTableViewCell"
            static let goalCell = "GoalTableViewCell"
        }
        struct Number {
            static let numberOfSections = 1
        }
    }
    
    var type: GoalType = .month {
        didSet {
            configureView(type: type)
        }
    }
    var goalSetter: GoalSettable! {
        didSet {
            tableView?.reloadData()
        }
    }
    
    fileprivate var isAdding: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        configureInitialState()
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    

}

// MARK: - view configuration
extension GoalTableViewController {
    func configureInitialState() {
        navigationController?.navigationBar.setColor(Utils.Style.Color.navigationItemBackgroundColor)
        navigationController?.navigationBar.configureNavigationBarTitle(color: Utils.Style.Color.navigationItemTitleColor, font: Utils.Style.Font.navigationItemTitleFont)
    }
    
    func configureView(type: GoalType) {
        switch type {
        case .month:
            navigationItem.title = Utils.TextLiteral.Style.goalViewControllerNavigationItemMonthText
        case .year:
            navigationItem.title = Utils.TextLiteral.Style.goalViewControllerNavigationItemYearText
        }
    }
}

// MARK: - UITableViewDataSource
extension GoalTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Constant.Number.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfGoals = goalSetter.goalsCount
        
        if (numberOfGoals == 0) {
            return 2
        } else {
            return numberOfGoals + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let goalSetter = goalSetter else {
            return tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.noGoalCell)!
        }
        
        if (goalSetter.goalsCount > 0 &&
            indexPath.row < goalSetter.goalsCount) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.goalCell) as? GoalTableViewCell,
                let goal = goalSetter.getGoal(at: indexPath.row) else {
                    return tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.noGoalCell)!
            }
            
            cell.configureCell(description: goal.description, goalState: goal.state.checkedViewState)
            cell.delegate = self
            
            return cell
        } else if (goalSetter.goalsCount > 0 ||
                   indexPath.row == 1) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.addNewGoalCell) as? AddNewGoalTableViewCell else {
                return tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.noGoalCell)!
            }
            
            cell.configureCell(editingStarted: isAdding)
            cell.delegate = self
            
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.noGoalCell)!
        }
    }
}


// MARK: - bridge between CheckedViewState and GoalState
extension GoalState {
    var checkedViewState: CheckedViewState {
        switch self {
        case .done:
            return CheckedViewState.done
        case .canceled:
            return CheckedViewState.canceled
        case .inProgress:
            return CheckedViewState.plain
        }
    }
    
    static func goalState(checkedViewState state: CheckedViewState) -> GoalState {
        switch state {
        case .done:
            return GoalState.done
        case .canceled:
            return GoalState.canceled
        case .plain:
            return GoalState.inProgress
        }

    }
}

// MARK: - GoalTableViewCellDelegate
extension GoalTableViewController : GoalTableViewCellDelegate {
    func deletingIsAllowed(for cell: GoalTableViewCell) -> Bool {
        return true
    }
    func deletionButtonTapped(for cell: GoalTableViewCell, completion: (Bool) -> Void) {
        guard let indexPath = tableView.indexPath(for: cell),
              let goal = goalSetter.getGoal(at: indexPath.row) else {
            completion(false)
            return
        }
        
        completion(goalSetter.removeGoal(goal: goal))
    }
    func goalStateChanged(for cell: GoalTableViewCell, newState state: CheckedViewState, completion: (Bool) -> Void) {
        guard let indexPath = tableView.indexPath(for: cell),
            let goal = goalSetter.getGoal(at: indexPath.row) else {
                completion(false)
                return
        }
        
        goal.state = GoalState.goalState(checkedViewState: state)
        completion(true)
    }
}

// MARK: - AddNewGoalTableViewCellDelegate
extension GoalTableViewController: AddNewGoalTableViewCellDelegate {
    func addNewGoal(description: String, completion: @escaping (Error?) -> Void) {
        goalSetter?.addNewGoal(description: description) { [weak self] (error) in
            if let error = error {
                self?.displayAlertOnView(title: Utils.TextLiteral.ServerError.serverErrorTitle, text: error.localizedDescription)
            } else {
                if ((self?.goalSetter.goalsCount ?? 0) == 1) {
                    self?.tableView.reloadRows(at: [IndexPath(row: (self?.goalSetter.goalsCount)! - 1, section: 0)], with: .fade)
                } else {
                    self?.tableView.insertRows(at: [IndexPath(row: (self?.goalSetter.goalsCount)! - 1, section: 0)], with: .fade)
                }
                
            }
            completion(error)
        }
    }
    
    func editingStateChanged(state: Bool) {
        isAdding = state
    }
}
