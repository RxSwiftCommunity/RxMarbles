//
//  SceneView.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 21.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SceneView: UIView {
    var animator: UIDynamicAnimator?
    var sourceTimeline: SourceTimelineView! {
        didSet {
            addSubview(sourceTimeline)
            
            if rxOperator.code.first != nil {
                sourceTimeline.labelsText = rxOperator.code.first
            }
            
            let initial = rxOperator.initial
            for t in initial.line1 {
               sourceTimeline.addEventToTimeline(t, animator: animator, isEditing: editing)
            }
        }
    }
    var secondSourceTimeline: SourceTimelineView! {
        didSet {
            addSubview(secondSourceTimeline)
            
            if rxOperator.code.last != nil {
                secondSourceTimeline.labelsText = rxOperator.code.last
            }
            
           
            let initial = rxOperator.initial
            for t in initial.line2 {
               secondSourceTimeline.addEventToTimeline(t, animator: animator, isEditing: editing)
            }
        }
    }
    var resultTimeline: ResultTimelineView! {
        didSet {
            addSubview(resultTimeline)
        }
    }
    var trashView = UIImageView(image: Image.trash)
    var rxOperator: Operator
    var editing: Bool!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(rxOperator: Operator) {
        self.rxOperator = rxOperator
        super.init(frame: CGRectZero)
        trashView.frame = CGRectMake(0, 0, 60, 60)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let defaultHeight: CGFloat = 70
        
        var firstHeight = defaultHeight
        if let firstCode = rxOperator.code.first {
            firstHeight += additionalHeight(firstCode.pre)
        }
        
        sourceTimeline.frame = CGRectMake(0, 80, bounds.size.width, firstHeight)
        refreshSourceEventsCenters(sourceTimeline)
        
        if secondSourceTimeline != nil {
            var secondHeight = defaultHeight
            if let secondCode = rxOperator.code.last {
                secondHeight += additionalHeight(secondCode.pre)
            }
            
            secondSourceTimeline.frame = CGRectMake(0, sourceTimeline.frame.origin.y + sourceTimeline.frame.height, bounds.size.width, secondHeight)
            refreshSourceEventsCenters(secondSourceTimeline)
            
            resultTimeline.frame = CGRectMake(0, secondSourceTimeline.frame.origin.y + secondSourceTimeline.frame.height, bounds.size.width, defaultHeight)
        } else {
            resultTimeline.frame = CGRectMake(0, sourceTimeline.frame.origin.y + sourceTimeline.frame.height, bounds.size.width, defaultHeight)
        }
        trashView.center.x = bounds.size.width / 2.0
        trashView.center.y = bounds.size.height - 50
        
        updateResultTimeline()
    }
    
    private func additionalHeight(pre: String) -> CGFloat {
        var addHeight: CGFloat = 0
        if pre != "" {
            addHeight += 20
        }
        return addHeight
    }
    
    private func refreshSourceEventsCenters(timeline: SourceTimelineView) {
        timeline.sourceEvents.forEach {
            $0.center.x = timeline.xPositionByTime($0.recorded.time)
            $0.center.y = timeline.bounds.height / 2.0
            if let snap = $0.snap {
                snap.snapPoint.x = CGFloat($0.recorded.time) >= 0 ? timeline.xPositionByTime($0.recorded.time) : 0.0
                snap.snapPoint.y = timeline.center.y
            }
        }
    }
    
    func updateResultTimeline() {
        if let secondSourceTimeline = secondSourceTimeline {
            resultTimeline.updateEvents((sourceTimeline.sourceEvents, secondSourceTimeline.sourceEvents))
        } else {
            resultTimeline.updateEvents((sourceTimeline.sourceEvents, nil))
        }
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