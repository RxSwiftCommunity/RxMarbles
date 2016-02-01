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
            
            let initial = rxOperator.initial
            for t in initial.line1 {
                sourceTimeline.addEventToTimeline(t, animator: animator)
            }
        }
    }
    var secondSourceTimeline: SourceTimelineView! {
        didSet {
            addSubview(secondSourceTimeline)

            let initial = rxOperator.initial
            for t in initial.line2 {
                secondSourceTimeline.addEventToTimeline(t, animator: animator)
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
    var editing: Bool = false {
        didSet {
            resultTimeline.editing = editing
            if !rxOperator.withoutTimelines {
                sourceTimeline.editing = editing
                if rxOperator.multiTimelines {
                    secondSourceTimeline.editing = editing
                }
            }
            setNeedsLayout()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(rxOperator: Operator, frame: CGRect) {
        self.rxOperator = rxOperator
        super.init(frame: frame)
        trashView.frame = CGRectMake(0, 0, 60, 60)
        animator = UIDynamicAnimator(referenceView: self)
        setTimelines()
    }
    
    private func setTimelines() {
        resultTimeline = ResultTimelineView(frame: CGRectMake(0, 0, bounds.width, 40), rxOperator: rxOperator, sceneView: self)
        if !rxOperator.withoutTimelines {
            sourceTimeline = SourceTimelineView(frame: CGRectMake(0, 0, bounds.width, 80), scene: self)
            if rxOperator.multiTimelines {
                secondSourceTimeline = SourceTimelineView(frame: CGRectMake(0, 0, bounds.width, 80), scene: self)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height: CGFloat = 60
    
        if !rxOperator.withoutTimelines {
            sourceTimeline.frame = CGRectMake(0, 80, bounds.width, height)
            refreshSourceEventsCenters(sourceTimeline)
            sourceTimeline.subject.onNext()
        
            if secondSourceTimeline != nil {
                
                secondSourceTimeline.frame = CGRectMake(0, sourceTimeline.frame.origin.y + sourceTimeline.frame.height, bounds.width, height)
                refreshSourceEventsCenters(secondSourceTimeline)
                secondSourceTimeline.subject.onNext()
            
                resultTimeline.frame = CGRectMake(0, secondSourceTimeline.frame.origin.y + secondSourceTimeline.frame.height, bounds.width, height)
            } else {
                resultTimeline.frame = CGRectMake(0, sourceTimeline.frame.origin.y + sourceTimeline.frame.height, bounds.width, height)
            }
        } else {
            resultTimeline.frame = CGRectMake(0, 80, bounds.width, height)
        }
        
        trashView.center = CGPointMake(bounds.width / 2.0, bounds.height - 50)
        resultTimeline.subject.onNext()
    }
    
    func refreshSourceEventsCenters(timeline: SourceTimelineView) {
        timeline.sourceEvents.forEach {
            $0.center.x = timeline.xPositionByTime($0.recorded.time)
            $0.center.y = timeline.bounds.height / 2.0
            if let snap = $0.snap {
                snap.snapPoint = CGPointMake(timeline.xPositionByTime($0.recorded.time), timeline.center.y)
            }
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