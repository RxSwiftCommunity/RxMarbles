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
        
        let valLeft  = NSValue(CATransform3D: CATransform3DMakeRotation(wobbleAngle, 0.0, 0.0, 1.0))
        let valRight = NSValue(CATransform3D: CATransform3DMakeRotation(-wobbleAngle, 0.0, 0.0, 1.0))
        animation.values = [valLeft, valRight]
        
        animation.autoreverses = true
        animation.duration = 0.125
        animation.repeatCount = 10000
        
        if view.layer.animationKeys() == nil {
            view.layer.addAnimation(animation, forKey: "shake")
        }
    }
    
    static func stopShake(view: UIView) {
        view.layer.removeAnimationForKey("shake")
    }
    
    static func hideWithCompletion(view: UIView, completion: (Bool) -> Void) {
        UIView.animateWithDuration(
            0.3,
            animations: {
                view.alpha = 0.01
                view.transform = CGAffineTransformMakeScale(0.1, 0.1)
            },
            completion: completion
        )
    }
    
    static func scale(view: UIView) {
        UIView.animateWithDuration(
            0.3,
            animations: {
                view.transform = CGAffineTransformMakeScale(4.0, 4.0)
                view.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }
        )
    }
    
    static func rotate(view:UIView, toAngle angle: CGFloat) {
        UIView.animateWithDuration(0.6) {
            if angle > 0.0 {
                view.transform = CGAffineTransformMakeRotation(angle)
                view.transform = CGAffineTransformTranslate(view.transform, 0.0, 3.0)
            } else {
                view.transform = CGAffineTransformIdentity
            }
        }
    }
    
    static func stopAll(view: UIView) {
        view.layer.removeAllAnimations()
    }
}