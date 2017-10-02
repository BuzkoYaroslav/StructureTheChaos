//
//  AddNewGoalTableViewCell.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 9/8/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import UIKit

protocol AddNewGoalTableViewCellDelegate {
    func addNewGoal(description: String, completion: @escaping (Error?) -> Void)
    func editingStateChanged(state: Bool)
}

class AddNewGoalTableViewCell: UITableViewCell {

    
    @IBOutlet weak var gapView: UIView!
    @IBOutlet weak var closeAdditionButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addGoalButton: LightButton!
    
    fileprivate var additionIsStarted: Bool = false
    
    var delegate: AddNewGoalTableViewCellDelegate?
    
    func configureCell(editingStarted state: Bool) {
        setHiddenPropertyToViews(value: !state)
        additionIsStarted = state
        
        let templateImage = closeAdditionButton?.imageView?.image?.withRenderingMode(.alwaysTemplate)
        closeAdditionButton.imageView?.image = templateImage
        closeAdditionButton.imageView?.tintColor = UIColor.green
    }
    
    @IBAction func closeAdditionButtonTapped(sender: UIButton) {
        if (additionIsStarted) {
            delegate?.editingStateChanged(state: false)
            hideElements()
        }
    }
    
    @IBAction func addButtonTapped(sender: UIButton) {
        if (!additionIsStarted) {
            delegate?.editingStateChanged(state: true)
            showElements()
        } else {
            delegate?.editingStateChanged(state: false)
            addNewGoal()
        }
    }

}

// MARK: - add new goal
extension AddNewGoalTableViewCell {
    func addNewGoal() {
        delegate?.addNewGoal(description: descriptionTextView.text) { [weak self] (error) in
            if let _ = error {
                self?.hideElements()
            }
        }
    }
}

// MARK: - managing element appearance
extension AddNewGoalTableViewCell {
    func showElements(animated: Bool, appearance: Bool) {
        if (!animated) {
            setHiddenPropertyToViews(value: !appearance)
            return
        }
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] () in
            self?.setHiddenPropertyToViews(value: !appearance)
        }) { [weak self] (finished) in
            if (finished && appearance) {
                self?.descriptionTextView.becomeFirstResponder()
            }
        }
    }
    fileprivate func setHiddenPropertyToViews(value: Bool) {
        gapView.isHidden = value
        descriptionTextView.isHidden = value
    }
    func hideElements() {
        showElements(animated: true, appearance: false)
        additionIsStarted = false
        
        updateSelfHeight()
    }
    func showElements() {
        showElements(animated: true, appearance: true)
        additionIsStarted = true
        
        updateSelfHeight()
    }
    
    func updateSelfHeight() {
        if let tableView = self.superview?.superview as? UITableView {
//            tableView.beginUpdates()
//            tableView.endUpdates()
            tableView.reloadRows(at: [IndexPath(row: tableView.numberOfRows(inSection: 0) - 1, section: 0)], with: UITableViewRowAnimation.fade)
        }
    }
}
