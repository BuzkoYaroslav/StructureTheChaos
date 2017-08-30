//
//  UINavigationBar+Colorful.swift
//  StructureTheChaos
//
//  Created by Yaroslav on 8/30/17.
//  Copyright © 2017 Yaroslav Buzko(C). All rights reserved.
//

import UIKit

// MARK: - create 1px x 1px foto to fill navigation bar
extension UIImage {
    class func image(forColor color: UIColor) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 1.0, height: 1.0))
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
}

// MARK: - set navigation bar color
extension UINavigationBar {
    func setColor(_ color: UIColor) {
        let colorImage = UIImage.image(forColor: color)
        
        setBackgroundImage(colorImage, for: .default)
        shadowImage = colorImage
        isTranslucent = false
    }
    
    func makeTransparent() {
        setColor(UIColor.clear)
        
        isTranslucent = true
    }
}
