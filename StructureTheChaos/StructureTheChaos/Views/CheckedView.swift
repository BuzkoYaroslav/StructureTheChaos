//
//  CheckedView.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 9/4/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import UIKit

enum CheckedViewState {
    case plain
    case done
    case canceled
}

@IBDesignable
class CheckedView: UIView {
    fileprivate struct Constant {
        struct Animation {
            static let changeStateAnimationDuration = 0.25
        }
    }

    @IBInspectable var doneStateColor: UIColor = UIColor.green {
        didSet {
            
        }
    }
    @IBInspectable var cancelStateColor: UIColor = UIColor.red {
        didSet {
            
        }
    }
    @IBInspectable var defaultStateColor: UIColor = UIColor.lightGray {
        didSet {
            
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    fileprivate var state: CheckedViewState = .plain
    
    
}

// MARK: - drawing on view 
extension CheckedView {
    override func draw(_ rect: CGRect) {
        
    }
    func drawDoneState(_ rect: CGRect) {
        
    }
    func drawCanceledState(_ rect: CGRect) {
        
    }
}

// MARK: - managing states
extension CheckedView {
    func changeState(to newState: CheckedViewState, animated: Bool) {
        if (newState == state) {
            return
        }
        
        state = newState
        setNeedsDisplay()
        if (animated) {
            UIView.transition(with: self, duration: Constant.Animation.changeStateAnimationDuration, options: .transitionCrossDissolve, animations: { 
                self.layer.displayIfNeeded()
            }, completion: nil)
        }
    }
    func nextState(animated: Bool) {
        switch state {
        case .plain:
            changeState(to: .done, animated: animated)
        case .done:
            changeState(to: .canceled, animated: animated)
        case .canceled:
            changeState(to: .plain, animated: animated)
        }
    }
}
