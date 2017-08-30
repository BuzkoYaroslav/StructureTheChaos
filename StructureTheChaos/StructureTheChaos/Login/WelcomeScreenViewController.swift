//
//  WelcomeScreenViewController.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 8/29/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import UIKit

class WelcomeScreenViewController: UIViewController {

    @IBOutlet weak var centerVerticallyImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    var centerVerticallyImageViewConstraintPreviousConstant: CGFloat = -40.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareInitialViewState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateControls(forAppearance: true)
    }
    
    func prepareInitialViewState() {
        navigationController?.navigationBar.setColor(loginButton.titleColor(for: .normal)!)
        
        loginButton.isHidden = true
        registerButton.isHidden = true
        
        loginButton.alpha = 0.0
        registerButton.alpha = 0.0
    }


}

// MARK: - animation
extension WelcomeScreenViewController {
    
    func animateControls(forAppearance appear: Bool) {
        let transitionDuration: TimeInterval = 1.0
        
        let previousConstant = centerVerticallyImageViewConstraint.constant
        centerVerticallyImageViewConstraint.constant = centerVerticallyImageViewConstraintPreviousConstant
        centerVerticallyImageViewConstraintPreviousConstant = previousConstant
        
        UIView.animate(withDuration: transitionDuration, delay: 0.0, options: .transitionCurlUp, animations: {	[weak self] in
            self?.view.layoutIfNeeded()
        }, completion: nil)
        
        animateControl(loginButton, forAppearance: appear, withDelay: transitionDuration)
        animateControl(registerButton, forAppearance: appear, withDelay: transitionDuration)
    }
    
    func animateControl(_ control: UIControl, forAppearance appear: Bool, withDelay delay: TimeInterval) {
        if (appear) {
            control.isHidden = false
        }
        
        UIView.animate(withDuration: 1.0, delay: delay, options: .showHideTransitionViews, animations: { 
            control.alpha = appear ? 1.0 : 0.0
        }) { (finished) in
            if (finished && !appear) { control.isHidden = true }
        }
    }
    
}
