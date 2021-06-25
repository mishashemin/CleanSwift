//
//  UIView+Ext.swift
//  CleanSwift
//
//  Created by m.shemin on 25.06.2021.
//

import UIKit

extension UIView {

    func startRotating() {
        guard self.layer.animation(forKey: "rotationAnimationExtension") == nil else {
            return
        }
        let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
        rotationAnimation.duration = 1
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = .greatestFiniteMagnitude
        self.layer.add(rotationAnimation, forKey: "rotationAnimationExtension")
    }

    func stopRotating() {
        self.layer.removeAnimation(forKey: "rotationAnimationExtension")
    }
}
