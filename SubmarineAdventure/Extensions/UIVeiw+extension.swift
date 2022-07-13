//
//  UIVeiw+extension.swift
//  SubmarineAdventure
//
//  Created by Sergey Pavlov on 02.06.2022.
//

import Foundation
import UIKit

extension UIView {
    func dropShadow() {
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.5
            layer.shadowOffset = CGSize(width: 10, height: 10)
            layer.shadowRadius = 10
            
            layer.shadowPath = UIBezierPath(rect: bounds).cgPath
            layer.shouldRasterize = true
    }
    func rounded(radius: CGFloat = 15) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    func roundedLess(radius: CGFloat = 5) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
}

extension UIView {
    func addBlurEffect() {
        var blurEffect: UIBlurEffect!
        blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.bounds
        blurredEffectView.alpha = 0
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurredEffectView)
    }
    
    func removeBlurEffect() {
        for subview in self.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
}
