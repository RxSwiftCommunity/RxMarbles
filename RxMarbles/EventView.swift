//
//  EventView.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 21.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum EventShape {
    case Circle
    case RoundedRect
    case Rhombus
    case Another
}

class EventView: UIView {
    var _recorded = RecordedType(time: 0, event: .Completed)
    weak var _animator: UIDynamicAnimator? = nil
    var snap: UISnapBehavior? = nil
    private var _gravity: UIGravityBehavior? = nil
    private var _removeBehavior: UIDynamicItemBehavior? = nil
    private weak var _timeLine: SourceTimelineView?
    private var _tapGestureRecognizer: UITapGestureRecognizer!
    private var _label = UILabel()
    
    init(recorded: RecordedType, shape: EventShape) {
        switch recorded.value {
        case let .Next(v):
            super.init(frame: CGRectMake(0, 0, 38, 38))
            center = CGPointMake(CGFloat(recorded.time), bounds.height)
            clipsToBounds = true
            backgroundColor = v.color
            layer.borderColor = UIColor.lightGrayColor().CGColor
            layer.borderWidth = 0.5
            _label.center = CGPointMake(19, 19)
            _label.textAlignment = .Center
            _label.font = UIFont(name: "", size: 17.0)
            _label.numberOfLines = 1
            _label.adjustsFontSizeToFitWidth = true
            _label.minimumScaleFactor = 0.6
            _label.lineBreakMode = .ByTruncatingTail
            _label.textColor = .whiteColor()
            addSubview(_label)
            
            if let value = recorded.value.element?.value {
                _label.text = String(value)
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
        
        _gravity = UIGravityBehavior(items: [self])
        _removeBehavior = UIDynamicItemBehavior(items: [self])
        _removeBehavior?.action = {
            let timeline = self._timeLine
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
        _recorded = recorded
        _tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "setEventView")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isNext {
            _label.frame = CGRectInset(frame, 3.0, 10.0)
            _label.center = CGPointMake(19, 19)
            _label.baselineAdjustment = .AlignCenters
        }
    }
    
    func use(animator: UIDynamicAnimator?, timeLine: SourceTimelineView?) {
        if let snap = snap {
            _animator?.removeBehavior(snap)
        }
        _animator = animator
        _timeLine = timeLine
        if let timeLine = timeLine {
            center.y = timeLine.bounds.height / 2
        }
        
        snap = UISnapBehavior(item: self, snapToPoint: CGPointMake(CGFloat(_recorded.time), center.y))
        userInteractionEnabled = _animator != nil
    }
    
    var isCompleted: Bool {
        if case .Completed = _recorded.value {
            return true
        } else {
            return false
        }
    }
    
    var isNext: Bool {
        if case .Next = _recorded.value {
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
        let settingsAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        
        if isNext {
            let contentViewController = UIViewController()
            contentViewController.preferredContentSize = CGSizeMake(200.0, 90.0)
            
            let eventView = EventView(recorded: _recorded, shape: (_recorded.value.element?.shape)!)
            eventView.center = CGPointMake(100.0, 25.0)
            contentViewController.view.addSubview(eventView)
            
            let colors = [RXMUIKit.lightBlueColor(), RXMUIKit.darkYellowColor(), RXMUIKit.lightGreenColor(), RXMUIKit.blueColor(), RXMUIKit.orangeColor()]
            let currentColor = _recorded.value.element?.color
            let colorsSegment = UISegmentedControl(items: ["", "", "", "", ""])
            colorsSegment.tintColor = .clearColor()
            colorsSegment.frame = CGRectMake(0.0, 50.0, 200.0, 30.0)
            var counter = 0
            colorsSegment.subviews.forEach({ subview in
                subview.backgroundColor = colors[counter]
                if currentColor == colors[counter] {
                    colorsSegment.selectedSegmentIndex = counter
                }
                counter++
            })
            
            if colorsSegment.selectedSegmentIndex < 0 {
                colorsSegment.selectedSegmentIndex = 0
            }
            
            contentViewController.view.addSubview(colorsSegment)
            
            settingsAlertController.setValue(contentViewController, forKey: "contentViewController")
            
            settingsAlertController.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                if let text = self._recorded.value.element?.value {
                    textField.text = text
                }
            })
            
            _ = Observable
                .combineLatest(settingsAlertController.textFields!.first!.rx_text, colorsSegment.rx_value, resultSelector: { text, segment in
                    return (text, segment)
                })
                .subscribeNext({ (text, segment) in
                    self.updatePreviewEventView(eventView, params: (color: colors[segment], value: text))
                })
            
            let saveAction = UIAlertAction(title: "Save", style: .Default) { (action) -> Void in
                self.saveAction(eventView)
            }
            settingsAlertController.addAction(saveAction)
        } else {
            settingsAlertController.message = "Delete event?"
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) -> Void in
            self.deleteAction()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in }
        settingsAlertController.addAction(deleteAction)
        settingsAlertController.addAction(cancelAction)
        // TODO: think and fix
//        if let parentViewController = self._parentViewController {
//            parentViewController.presentViewController(settingsAlertController, animated: true) { () -> Void in }
//        }
        if let viewControler = UIApplication.sharedApplication().keyWindow?.rootViewController {
            viewControler.presentViewController(settingsAlertController, animated: true, completion: nil)
        }
    }
    
    private func saveAction(eventView: EventView) {
        let index = _timeLine?.sourceEvents.indexOf(self)
        let time = eventView._recorded.time
        if index != nil {
            _timeLine?.sourceEvents.removeAtIndex(index!)
            removeFromSuperview()
            _timeLine?.addNextEventToTimeline(time, event: eventView._recorded.value, animator: _animator, isEditing: true)
            _timeLine?.updateResultTimeline()
        }
    }
    
    private func deleteAction() {
        _animator!.removeAllBehaviors()
        _animator!.addBehavior(_gravity!)
        _animator!.addBehavior(_removeBehavior!)
        // TODO: rethink
//        _removeBehavior?.action = {
//            if let superView = self._parentViewController.sceneView {
//                if let index = self._timeLine?._sourceEvents.indexOf(self) {
//                    if CGRectIntersectsRect(superView.bounds, self.frame) == false {
//                        self.removeFromSuperview()
//                        self._timeLine?._sourceEvents.removeAtIndex(index)
//                        self._timeLine?.updateResultTimeline()
//                    }
//                }
//            }
//        }
    }
    
    private func updatePreviewEventView(eventView: EventView, params: (color: UIColor, value: String)) {
        let time = eventView._recorded.time
        let shape = _recorded.value.element?.shape
        let event = Event.Next(ColoredType(value: params.value, color: params.color, shape: shape!))
        
        eventView._recorded = RecordedType(time: time, event: event)
        eventView._label.text = params.value
        eventView.backgroundColor = params.color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
