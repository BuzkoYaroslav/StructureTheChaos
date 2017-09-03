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
    var centerVerticallyImageViewConstraintConstant: CGFloat = -40.0
    private var firstAppearance = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareInitialViewState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (LoginModel.isAuthorized) {
            navigateToPlanViewController()
        }
        if (firstAppearance) {
            animateControls(forAppearance: true)
            firstAppearance = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.makeTransparent()
    }
    
    
    func prepareInitialViewState() {
        loginButton.isHidden = true
        registerButton.isHidden = true
        
        loginButton.alpha = 0.0
        registerButton.alpha = 0.0
    }


}

// MARK: - navigation
extension WelcomeScreenViewController {
    func navigateToPlanViewController() {
        
    }
}

// MARK: - animation
extension WelcomeScreenViewController {
    
    func animateControls(forAppearance appear: Bool) {
        let transitionDuration: TimeInterval = 1.0

        centerVerticallyImageViewConstraint.constant = centerVerticallyImageViewConstraintConstant

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
