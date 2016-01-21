//
//  SceneView.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 21.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit

class SceneView: UIView {
    var animator: UIDynamicAnimator?
    var sourceTimeline: SourceTimelineView!
    var secondSourceTimeline: SourceTimelineView!
    var resultTimeline: ResultTimelineView!
    
    var trashView = UIImageView(image: Image.trash)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRectZero)
    }
    
    func showTrashView() {
        trashView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trashView)
        addConstraint(NSLayoutConstraint(item: trashView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        let metrics = ["size" : 60.0]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[trash(==size)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: ["trash" : trashView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[trash(==size)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: ["trash" : trashView]))
       
        trashView.hidden = false
        trashView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        trashView.alpha = 0.05
        UIView.animateWithDuration(0.3) { _ in
            self.trashView.alpha = 0.2
            self.trashView.transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.trashView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        }
    }
    
    func hideTrashView() {
        trashView.hideWithCompletion({ _ in })
    }
    
}