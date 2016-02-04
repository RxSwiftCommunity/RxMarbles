//
//  UIView.swift
//  RxMarbles
//
//  Created by Yury Korolev on 1/22/16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
//    MARK: Animations
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        let wobbleAngle: CGFloat = 0.3
        
        let valLeft = NSValue(CATransform3D:CATransform3DMakeRotation(wobbleAngle, 0.0, 0.0, 1.0))
        let valRight = NSValue(CATransform3D:CATransform3DMakeRotation(-wobbleAngle, 0.0, 0.0, 1.0))
        animation.values = [valLeft, valRight]
        
        animation.autoreverses = true
        animation.duration = 0.125
        animation.repeatCount = 10000
        
        if layer.animationKeys() == nil {
            layer.addAnimation(animation, forKey: "shake")
        }
    }
    
    func stopShakeAnimation() {
        self.layer.removeAnimationForKey("shake")
    }
    
    func hideWithCompletion(completion: (Bool) -> Void) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.alpha = 0.01
            self.transform = CGAffineTransformMakeScale(0.1, 0.1)
            }, completion: completion)
    }
    
    func scaleAnimation() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(4.0, 4.0)
            self.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
    }
    
    func rotateToAngle(angle: CGFloat) {
        UIView.animateWithDuration(0.6) {
            if angle > 0.0 {
                self.transform = CGAffineTransformMakeRotation(angle)
                self.transform = CGAffineTransformTranslate(self.transform, 0.0, 3.0)
            } else {
                self.transform = CGAffineTransformIdentity
            }
        }
    }
    
    func stopAnimations() {
        self.layer.removeAllAnimations()
    }
}