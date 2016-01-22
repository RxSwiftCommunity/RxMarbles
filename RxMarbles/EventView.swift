//
//  EventView.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 21.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit
import RxSwift

class EventView: UIView {
    var recorded = RecordedType(time: 0, event: .Completed)
    weak var animator: UIDynamicAnimator? = nil
    var snap: UISnapBehavior? = nil
    var gravity: UIGravityBehavior? = nil
    var removeBehavior: UIDynamicItemBehavior? = nil
    weak var timeLine: SourceTimelineView?
    private var _tapGestureRecognizer: UITapGestureRecognizer!
    var label = UILabel()
    
    init(recorded: RecordedType, shape: EventShape) {
        switch recorded.value {
        case let .Next(v):
            super.init(frame: CGRectMake(0, 0, 38, 38))
            center = CGPointMake(CGFloat(recorded.time), bounds.height)
            clipsToBounds = true
            backgroundColor = v.color
            layer.borderColor = UIColor.lightGrayColor().CGColor
            layer.borderWidth = 0.5
            label.center = CGPointMake(19, 19)
            label.textAlignment = .Center
            label.font = UIFont(name: "", size: 17.0)
            label.numberOfLines = 1
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.6
            label.lineBreakMode = .ByTruncatingTail
            label.textColor = .whiteColor()
            addSubview(label)
            
            if let value = recorded.value.element?.value {
                label.text = String(value)
            }
            switch shape {
            case .Circle:
                layer.cornerRadius = bounds.width / 2.0
            case .RoundedRect:
                layer.cornerRadius = 5.0
            case .Rhombus:
                let width = layer.frame.size.width
                let height = layer.frame.size.height
                
                let mask = CAShapeLayer()
                mask.frame = layer.bounds
                
                let path = CGPathCreateMutable()
                CGPathMoveToPoint(path, nil, width / 2.0, 0)
                CGPathAddLineToPoint(path, nil, width, height / 2.0)
                CGPathAddLineToPoint(path, nil, width / 2.0, height)
                CGPathAddLineToPoint(path, nil, 0, height / 2.0)
                CGPathAddLineToPoint(path, nil, width / 2.0, 0)
                
                mask.path = path
                layer.mask = mask
                
                let border = CAShapeLayer()
                border.frame = bounds
                border.path = path
                border.lineWidth = 0.5
                border.strokeColor = UIColor.lightGrayColor().CGColor
                border.fillColor = UIColor.clearColor().CGColor
                layer.insertSublayer(border, atIndex: 0)
                
            case .Another:
                break
            }
            
        case .Completed:
            super.init(frame: CGRectMake(0, 0, 37, 38))
            center = CGPointMake(CGFloat(recorded.time), bounds.height)
            backgroundColor = .clearColor()
            
            let grayLine = UIView(frame: CGRectMake(17.5, 5, 3, 28))
            grayLine.backgroundColor = .grayColor()
            
            addSubview(grayLine)
            
            bringSubviewToFront(self)
        case .Error:
            super.init(frame: CGRectMake(0, 0, 37, 38))
            center = CGPointMake(CGFloat(recorded.time), bounds.height)
            backgroundColor = .clearColor()
            
            let firstLineCross = UIView(frame: CGRectMake(17.5, 7.5, 3, 23))
            firstLineCross.backgroundColor = .grayColor()
            firstLineCross.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 0.25))
            addSubview(firstLineCross)
            
            let secondLineCross = UIView(frame: CGRectMake(17.5, 7.5, 3, 23))
            secondLineCross.backgroundColor = .grayColor()
            secondLineCross.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 0.75))
            addSubview(secondLineCross)
            
            bringSubviewToFront(self)
        }
        
        gravity = UIGravityBehavior(items: [self])
        removeBehavior = UIDynamicItemBehavior(items: [self])
        removeBehavior?.action = {
            let timeline = self.timeLine
            if let viewController = UIApplication.sharedApplication().keyWindow?.rootViewController {
                if let index = timeline?.sourceEvents.indexOf(self) {
                    if CGRectIntersectsRect(viewController.view.bounds, self.frame) == false {
                        self.removeFromSuperview()
                        timeline?.sourceEvents.removeAtIndex(index)
                        timeline!.updateResultTimeline()
                    }
                }
            }
        }
        self.recorded = recorded
        _tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "setEventView")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isNext {
            label.frame = CGRectInset(frame, 3.0, 10.0)
            label.center = CGPointMake(19, 19)
            label.baselineAdjustment = .AlignCenters
        }
    }
    
    func use(animator: UIDynamicAnimator?, timeLine: SourceTimelineView?) {
        if let snap = snap {
            animator?.removeBehavior(snap)
        }
        self.animator = animator
        self.timeLine = timeLine
        if let timeLine = timeLine {
            center.y = timeLine.bounds.height / 2
        }
        
        snap = UISnapBehavior(item: self, snapToPoint: CGPointMake(CGFloat(recorded.time), center.y))
        userInteractionEnabled = animator != nil
    }
    
    var isCompleted: Bool {
        if case .Completed = recorded.value {
            return true
        } else {
            return false
        }
    }
    
    var isNext: Bool {
        if case .Next = recorded.value {
            return true
        } else {
            return false
        }
    }
    
    func addTapRecognizer() {
        addGestureRecognizer(_tapGestureRecognizer!)
    }
    
    func removeTapRecognizer() {
        removeGestureRecognizer(_tapGestureRecognizer!)
    }
    
    func setEventView() {
        NSNotificationCenter.defaultCenter().postNotificationName("SetEventView", object: self, userInfo: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
