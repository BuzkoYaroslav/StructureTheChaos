//
//  UIViewController+Alert.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 9/1/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import UIKit

// MARK: - displaying alert on view
extension UIViewController {
    func displayAlertOnView(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    func displayAlertOnView(title: String, text: String, alertHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alertHandler()
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
