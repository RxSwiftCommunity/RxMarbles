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
    weak var animator: UIDynamicAnimator? = nil
    weak var timeLine: SourceTimelineView?
    
    var recorded = RecordedType(time: 0, event: .Completed)
    
    var snap: UISnapBehavior? = nil
    var gravity: UIGravityBehavior? = nil
    var removeBehavior: UIDynamicItemBehavior? = nil
    
    private let _tapGestureRecognizer = UITapGestureRecognizer()
    private let _imageView = UIImageView()
    
    var label = UILabel()
    
    init(recorded: RecordedType) {
        super.init(frame: CGRectMake(0, 0, 38, 50))
       
        _imageView.contentMode = .Center
        label.textColor = Color.black
        label.font = UIFont.systemFontOfSize(11, weight: UIFontWeightUltraLight)
        addSubview(_imageView)
        addSubview(label)
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale //.rasterizationScale = [[UIScreen mainScreen] scale];
        
        switch recorded.value {
        case let .Next(v):
            if let value = recorded.value.element?.value {
                label.text = value
                label.sizeToFit()
            }

            _imageView.image = v.shape.image
            _imageView.frame = CGRectMake(0, 0, 16, 16)
            _imageView.tintColor = v.color
            _imageView.layer.shadowColor = UIColor.blackColor().CGColor
            _imageView.layer.shadowOffset = CGSizeMake(0, 0)
            _imageView.layer.shadowRadius = 0.75
            _imageView.layer.shadowOpacity = 1.0
        case .Completed:
            _imageView.image = Image.complete
            _imageView.tintColor = Color.black
        case .Error:
            _imageView.image = Image.error
            _imageView.tintColor = Color.black
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
                        timeline!.sceneView.updateResultTimeline()
                    }
                }
            }
        }
        self.recorded = recorded
        _tapGestureRecognizer.addTarget(self, action: "setEventView")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _imageView.center = CGPointMake(bounds.width / 2.0, bounds.height / 2.0)
        label.center = CGPointMake(bounds.width / 2.0, bounds.height * 0.15)
    }
    
    func use(animator: UIDynamicAnimator?, timeLine: SourceTimelineView?) {
        if let snap = snap {
            animator?.removeBehavior(snap)
        }
        self.animator = animator
        self.timeLine = timeLine
        if let timeLine = timeLine {
            let x = timeLine.xPositionByTime(recorded.time)
            center = CGPointMake(x, timeLine.bounds.height / 2.0)
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
        addGestureRecognizer(_tapGestureRecognizer)
    }
    
    func removeTapRecognizer() {
        removeGestureRecognizer(_tapGestureRecognizer)
    }
    
    func setEventView() {
        NSNotificationCenter.defaultCenter().postNotificationName("SetEventView", object: self, userInfo: nil)
    }
    
    func setGhostColorByOnDeleteZone(onDeleteZone: Bool) {
        let color: UIColor = onDeleteZone ? .redColor() : .grayColor()
        let alpha: CGFloat = onDeleteZone ? 1.0 : 0.2
        if recorded.value.isStopEvent {
            _imageView.image = isCompleted ? Image.complete.imageWithRenderingMode(.AlwaysTemplate) : Image.error.imageWithRenderingMode(.AlwaysTemplate)
        }
        _imageView.tintColor = color
        self.alpha = alpha
    }
    
    func setColorOnPreview(color: UIColor) {
        _imageView.tintColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
