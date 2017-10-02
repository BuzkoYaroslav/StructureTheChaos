//
//  GoalTableViewCell.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 9/8/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import UIKit

protocol GoalTableViewCellDelegate {
    func deletingIsAllowed(for cell: GoalTableViewCell) -> Bool
    func deletionButtonTapped(for cell: GoalTableViewCell, completion: (Bool) -> Void)
    func goalStateChanged(for cell: GoalTableViewCell, newState state: CheckedViewState, completion: (Bool) -> Void)
}

class GoalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var goalProgressCheckedView: CheckedView!
    @IBOutlet weak var goalDescriptionTextView: UITextView!
    @IBOutlet weak var goalDeletionButton: UIButton!
    
    var delegate: GoalTableViewCellDelegate?
    
    var indexPath: IndexPath {
        guard let tableView = superview as? UITableView else {
            return IndexPath()
        }
        
        return tableView.indexPath(for: self) ?? IndexPath()
    }
    
    func configureCell(description: String, goalState state: CheckedViewState) {
        goalProgressCheckedView.changeState(to: state, animated: false)
        goalDescriptionTextView.text = description
        
        goalProgressCheckedView.delegate = self
    }
    
    @IBAction func deletionButtonTapped(sender: UIButton) {
        if ((delegate?.deletingIsAllowed(for: self) ?? true)) {
            delegate?.deletionButtonTapped(for: self) { [weak self] (deleted) in
                if (deleted) {
                    self?.removeCellFromTableView()
                }
            }
        }
    }

    func removeCellFromTableView() {
        guard let tableView = superview as? UITableView else {
            return
        }
        
        let index = indexPath
        
        tableView.deleteRows(at: [index], with: UITableViewRowAnimation.top)
    }
}

// MARK: - CheckedViewDelegate
extension GoalTableViewCell : CheckedViewDelegate {
    func stateChanged(to state: CheckedViewState) {
        delegate?.goalStateChanged(for: self, newState: state) { [weak self] (finished) in
            if (!finished) {
                self?.goalProgressCheckedView.reversePreviousState()
            }
        }
    }
}
