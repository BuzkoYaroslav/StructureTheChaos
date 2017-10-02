//
//  CheckedView.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 9/4/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import UIKit
import QuartzCore

enum CheckedViewState {
    case plain
    case done
    case canceled
}

protocol CheckedViewDelegate {
    func stateChanged(to state: CheckedViewState)
}

@IBDesignable
class CheckedView: UIView {

    @IBInspectable var doneStateColor: UIColor = UIColor.green {
        didSet {
            if (state == .done) {
                setNeedsDisplay()
                layer.borderColor = doneStateColor.cgColor
            }
        }
    }
    @IBInspectable var cancelStateColor: UIColor = UIColor.red {
        didSet {
            if (state == .canceled) {
                setNeedsDisplay()
                layer.borderColor = cancelStateColor.cgColor
            }
        }
    }
    @IBInspectable var defaultStateColor: UIColor = UIColor.lightGray {
        didSet {
            if (state == .plain) {
                setNeedsDisplay()
                layer.borderColor = defaultStateColor.cgColor
            }
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
    @IBInspectable var signWidth: CGFloat = 5.0 {
        didSet {
            if (state != .plain) {
                setNeedsDisplay()
            }
        }
    }
    
    var delegate: CheckedViewDelegate?
    
    fileprivate var state: CheckedViewState = .plain
    fileprivate var previousState: CheckedViewState?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTapGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupTapGestureRecognizer()
    }
    
    func setupTapGestureRecognizer() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    func viewTapped(recognizer: UITapGestureRecognizer) {
        nextState(animated: true)
    
        delegate?.stateChanged(to: state)
    }
}

// MARK: - drawing on view 
extension CheckedView {
    override func draw(_ rect: CGRect) {
        switch state {
        case .done:
            drawDoneState(rect)
        case .canceled:
            drawCanceledState(rect)
        default:
            break
        }
    }
    func drawDoneState(_ rect: CGRect) {
        if (state != .done) {
            return
        }
        
        let path = UIBezierPath()
        
        path.lineWidth = signWidth
        
        path.move(to: CGPoint(x: Utils.Style.Number.doneStateCheckedViewMargin, y: rect.size.height / 2))
        path.addLine(to: CGPoint(x: rect.size.width / 2, y: rect.size.height - Utils.Style.Number.doneStateCheckedViewMargin))
        path.addLine(to: CGPoint(x: rect.size.width - Utils.Style.Number.doneStateCheckedViewMargin, y: Utils.Style.Number.doneStateCheckedViewMargin))
        
        doneStateColor.setStroke()
        
        path.stroke()
    }
    func drawCanceledState(_ rect: CGRect) {
        if (state != .canceled) {
            return
        }
        
        let path = UIBezierPath()
        
        path.lineWidth = signWidth
        
        path.move(to: CGPoint(x: Utils.Style.Number.canceledStateCheckedViewMargin, y: Utils.Style.Number.canceledStateCheckedViewMargin))
        path.addLine(to: CGPoint(x: rect.size.width - Utils.Style.Number.canceledStateCheckedViewMargin, y: rect.size.height - Utils.Style.Number.canceledStateCheckedViewMargin))
        path.move(to: CGPoint(x: rect.size.width - Utils.Style.Number.canceledStateCheckedViewMargin, y: Utils.Style.Number.canceledStateCheckedViewMargin))
        path.addLine(to: CGPoint(x: Utils.Style.Number.canceledStateCheckedViewMargin, y: rect.size.height - Utils.Style.Number.canceledStateCheckedViewMargin))
        
        cancelStateColor.setStroke()
        
        path.stroke()
    }
}

// MARK: - managing states
extension CheckedView {
    func changeState(to newState: CheckedViewState, animated: Bool) {
        if (newState == state) {
            return
        }
        
        previousState = state
        state = newState
        configureState()
        
        setNeedsDisplay()
        if (animated) {
            UIView.transition(with: self, duration: Utils.Animation.changeStateCheckedViewAnimationDuration, options: .transitionCrossDissolve, animations: {
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
    func configureState() {
        switch state {
        case .done:
            layer.borderColor = doneStateColor.cgColor
        case .canceled:
            layer.borderColor = cancelStateColor.cgColor
        case .plain:
            layer.borderColor = defaultStateColor.cgColor
        }
    }
    func reversePreviousState() {
        guard let previousState = previousState else {
            return
        }
        
        changeState(to: previousState, animated: true)
    }
}
