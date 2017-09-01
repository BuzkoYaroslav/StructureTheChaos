//
//  UIViewController+ActivityIndicator.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 9/1/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import UIKit

// MARK: - activity indicator
extension UIViewController {
    
    func activityInicator() -> UIActivityIndicatorView {
        let ai = UIActivityIndicatorView(frame: navigationController?.view.bounds ?? view.bounds)
        ai.activityIndicatorViewStyle = .whiteLarge
        ai.backgroundColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 0.5)
        
        return ai
    }
}
