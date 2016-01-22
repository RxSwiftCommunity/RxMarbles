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
        trashView.frame = CGRectMake(0, 0, 60, 60)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resultTimeline.frame = CGRectMake(0, 0, bounds.size.width, 40)
        resultTimeline.center.y = center.y
        sourceTimeline.frame = CGRectMake(0, 0, bounds.size.width, 40)
        sourceTimeline.center.y = center.y * 0.33
        if secondSourceTimeline != nil {
            secondSourceTimeline.frame = CGRectMake(0, 0, bounds.size.width, 40)
            secondSourceTimeline.center.y = center.y * 0.66
        }
        trashView.center.x = bounds.size.width / 2.0
        trashView.center.y = bounds.size.height - 50
    }
    
    func showTrashView() {
        addSubview(trashView)
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
        trashView.hideWithCompletion({ _ in self.trashView.removeFromSuperview() })
    }
    
}