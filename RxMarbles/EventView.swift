//
//  EventView.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 21.01.16.
//  Copyright © 2016 AnjLab. All rights reserved.
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
        super.init(frame: CGRectMake(0, 0, 42, 50))
       
        _imageView.contentMode = .Center
        label.textColor = Color.black
        label.font = Font.ultraLightText(11)
        addSubview(_imageView)
        addSubview(label)
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
        
        switch recorded.value {
        case let .Next(v):
            if let value = recorded.value.element?.value {
                label.text = value
                label.sizeToFit()
            }

            _imageView.image = v.shape.image(v.color)
            _imageView.frame = CGRectMake(0, 0, 16, 16)
        case .Completed:
            _imageView.image = Image.complete
            _imageView.tintColor = Color.black
            layer.zPosition = -1
        case .Error:
            _imageView.image = Image.error
            _imageView.tintColor = Color.black
            layer.zPosition = -1
        }
      
        
        gravity = UIGravityBehavior(items: [self])
        removeBehavior = UIDynamicItemBehavior(items: [self])
        removeBehavior?.action = {
            let timeline = self.timeLine
            if let scene = timeline?.sceneView {
                if let index = timeline?.sourceEvents.indexOf(self) {
                    if CGRectIntersectsRect(scene.bounds, self.frame) == false {
                        self.removeFromSuperview()
                        timeline?.sourceEvents.removeAtIndex(index)
                        scene.resultTimeline.subject.onNext()
                    }
                }
            }
        }
        self.recorded = recorded
        _tapGestureRecognizer.addTarget(self, action: "setEventView")
        _tapGestureRecognizer.enabled = false
        addGestureRecognizer(_tapGestureRecognizer)
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
            snap = UISnapBehavior(item: self, snapToPoint: CGPointMake(x, center.y))
        }
        
        
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
    
    var isError: Bool {
        if case .Error = recorded.value {
            return true
        } else {
            return false
        }
    }
    
    func addTapRecognizer() {
        _tapGestureRecognizer.enabled = true
    }
    
    func removeTapRecognizer() {
        _tapGestureRecognizer.enabled = false
    }
    
    func setEventView() {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.setEventView, object: self, userInfo: nil)
    }
    
    func setGhostColorOnDeleteZone(onDeleteZone: Bool) {
        let color: UIColor = onDeleteZone ? .redColor() : .grayColor()
        let alpha: CGFloat = onDeleteZone ? 1.0 : 0.2
        switch recorded.value {
        case .Next:
            _imageView.image = recorded.value.element?.shape.image.imageWithRenderingMode(.AlwaysTemplate)
        case .Completed:
            _imageView.image = Image.complete.imageWithRenderingMode(.AlwaysTemplate)
        case .Error:
            _imageView.image = Image.error.imageWithRenderingMode(.AlwaysTemplate)
        }
        _imageView.tintColor = color
        self.alpha = alpha
    }
    
    func setColorOnPreview(color: UIColor) {
        _imageView.image = recorded.value.element?.shape.image(color)
    }
    
    func refreshColorAndValue() {
        if let color = recorded.value.element?.color {
            _imageView.image = recorded.value.element?.shape.image(color)
        }
        if let value = recorded.value.element?.value {
            label.text = value
            label.sizeToFit()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
