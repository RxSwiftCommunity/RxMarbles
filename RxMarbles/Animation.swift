//
//  UIView.swift
//  RxMarbles
//
//  Created by Yury Korolev on 1/22/16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import Foundation
import UIKit

struct Animation {
    
    static func shake(view: UIView) {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        let wobbleAngle: CGFloat = 0.3
        
        let valLeft  = CATransform3DMakeRotation(wobbleAngle, 0.0, 0.0, 1.0)
        let valRight = CATransform3DMakeRotation(-wobbleAngle, 0.0, 0.0, 1.0)
        animation.values = [valLeft, valRight].map(NSValue.init)
        
        animation.autoreverses = true
        animation.duration = 0.125
        animation.repeatCount = 10000
        
        if view.layer.animationKeys() == nil {
            view.layer.add(animation, forKey: "shake")
        }
    }
    
    static func stopShake(view: UIView) {
        view.layer.removeAnimation(forKey: "shake")
    }
    
    static func hideWithCompletion(_ view: UIView, completion: @escaping (Bool) -> Void) {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                view.alpha = 0.01
                view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            },
            completion: completion
        )
    }
    
    static func scale(_ view: UIView) {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                view.transform = CGAffineTransform(scaleX: 4.0, y: 4.0)
                view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        )
    }
    
    static func rotate(_ view:UIView, toAngle angle: CGFloat) {
        UIView.animate(withDuration: 0.6) {
            if angle > 0.0 {
                view.transform = CGAffineTransform(rotationAngle: angle)
                view.transform = view.transform.translatedBy(x: 0.0, y: 3.0)
            } else {
                view.transform = CGAffineTransform.identity
            }
        }
    }
    
    static func stopAll(view: UIView) {
        view.layer.removeAllAnimations()
    }
}
