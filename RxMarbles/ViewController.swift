//
//  ViewController.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 06.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct ColoredType: Equatable {
    var value: String
    var color: UIColor
    var shape: EventShape
}

struct TimelineImage {
    static var timeLine: UIImage { return UIImage(named: "timeLine")! }
    static var cross: UIImage { return UIImage(named: "cross")! }
}

enum EventShape {
    case Circle
    case RoundedRect
    case Rhombus
    case Another
}

func ==(lhs: ColoredType, rhs: ColoredType) -> Bool {
    return lhs.value == rhs.value && lhs.color == rhs.color && lhs.shape == rhs.shape
}

typealias RecordedType = Recorded<Event<ColoredType>>

class EventView: UIView {
    private var _recorded = RecordedType(time: 0, event: .Completed)
    private weak var _animator: UIDynamicAnimator? = nil
    private var _snap: UISnapBehavior? = nil
    private var _gravity: UIGravityBehavior? = nil
    private var _removeBehavior: UIDynamicItemBehavior? = nil
    private weak var _timeLine: SourceTimelineView?
    private var _tapGestureRecognizer: UITapGestureRecognizer!
    private var _parentViewController: ViewController!
    private var _label = UILabel()
    
    init(recorded: RecordedType, shape: EventShape, viewController: ViewController!) {
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
                mask.frame = self.layer.bounds
                
                let path = CGPathCreateMutable()
                CGPathMoveToPoint(path, nil, width / 2.0, 0)
                CGPathAddLineToPoint(path, nil, width, height / 2.0)
                CGPathAddLineToPoint(path, nil, width / 2.0, height)
                CGPathAddLineToPoint(path, nil, 0, height / 2.0)
                CGPathAddLineToPoint(path, nil, width / 2.0, 0)
                
                mask.path = path
                self.layer.mask = mask
                
                let border = CAShapeLayer()
                border.frame = bounds
                border.path = path
                border.lineWidth = 0.5
                border.strokeColor = UIColor.lightGrayColor().CGColor
                border.fillColor = UIColor.clearColor().CGColor
                self.layer.insertSublayer(border, atIndex: 0)
                
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
        _recorded = recorded
        _tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "setEventView")
        _parentViewController = viewController
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
        if let snap = _snap {
            _animator?.removeBehavior(snap)
        }
        _animator = animator
        _timeLine = timeLine
        if let timeLine = timeLine {
            center.y = timeLine.bounds.height / 2
        }

        _snap = UISnapBehavior(item: self, snapToPoint: CGPointMake(CGFloat(_recorded.time), center.y))
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
            
            let eventView = EventView(recorded: self._recorded, shape: (self._recorded.value.element?.shape)!, viewController: _parentViewController)
            eventView.center = CGPointMake(100.0, 25.0)
            contentViewController.view.addSubview(eventView)
            
            let colors = [RXMUIKit.lightBlueColor(), RXMUIKit.darkYellowColor(), RXMUIKit.lightGreenColor(), RXMUIKit.blueColor(), RXMUIKit.orangeColor()]
            let currentColor = self._recorded.value.element?.color
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
                    eventView._label.text = text
                    eventView.backgroundColor = colors[segment]
                })
            
            let saveAction = UIAlertAction(title: "Save", style: .Default) { (action) -> Void in
                let index = self._timeLine?._sourceEvents.indexOf(self)
                let time = self._recorded.time
                let value = eventView._label.text
                let color = eventView.backgroundColor
                let shape = self._recorded.value.element?.shape
                let event = Event.Next(ColoredType(value: value!, color: color!, shape: shape!))
                if index != nil {
                    self._timeLine?._sourceEvents.removeAtIndex(index!)
                    self.removeFromSuperview()
                    self._timeLine?.addNextEventToTimeline(time, event: event, animator: self._parentViewController._sceneView.animator, isEditing: true)
                    self._timeLine?.updateResultTimeline()
                }
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
        if let parentViewController = self._parentViewController {
            parentViewController.presentViewController(settingsAlertController, animated: true) { () -> Void in }
        }
    }
    
    private func deleteAction() {
        self._animator!.removeAllBehaviors()
        self._animator!.addBehavior(self._gravity!)
        self._animator!.addBehavior(self._removeBehavior!)
        self._removeBehavior?.action = {
            if let superView = self._parentViewController._sceneView {
                if let index = self._timeLine?._sourceEvents.indexOf(self) {
                    if CGRectIntersectsRect(superView.bounds, self.frame) == false {
                        self.removeFromSuperview()
                        self._timeLine?._sourceEvents.removeAtIndex(index)
                        self._timeLine?.updateResultTimeline()
                    }
                }
            }
        }
    }
    
    private func scaleAnimation() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(4.0, 4.0)
            self.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class TimelineView: UIView {
    var _sourceEvents = [EventView]()
    let _timeArrow = UIImageView(image: TimelineImage.timeLine)
    private var _addButton: UIButton?
    var _parentViewController: ViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(_timeArrow)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frame = CGRectMake(10, frame.origin.y, (superview?.bounds.size.width)! - 20, 40)
        _timeArrow.frame = CGRectMake(0, 16, frame.width, TimelineImage.timeLine.size.height)
        if _addButton != nil {
            _addButton?.center.y = _timeArrow.center.y
            _addButton?.center.x = frame.size.width - 10.0
            let timeArrowFrame = self._timeArrow.frame
            let newTimeArrowFrame = CGRectMake(timeArrowFrame.origin.x, timeArrowFrame.origin.y, timeArrowFrame.size.width - 23.0, timeArrowFrame.size.height)
            self._timeArrow.frame = newTimeArrowFrame
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func maxNextTime() -> Int? {
        var times = Array<Int>()
        _sourceEvents.forEach { (eventView) -> () in
            if eventView.isNext {
                times.append(eventView._recorded.time)
            }
        }
        return times.maxElement()
    }
}

class SourceTimelineView: TimelineView {
    
    private let _longPressGestureRecorgnizer = UILongPressGestureRecognizer()
    private var _panEventView: EventView?
    private var _ghostEventView: EventView?
    private var _sceneView: SceneView!
    
    init(frame: CGRect, resultTimeline: ResultTimelineView) {
        super.init(frame: frame)
        userInteractionEnabled = true
        clipsToBounds = false
        
        _longPressGestureRecorgnizer.minimumPressDuration = 0.0
        
        addGestureRecognizer(_longPressGestureRecorgnizer)
        
        _ = _longPressGestureRecorgnizer.rx_event
            .subscribeNext { [weak self] r in
                
                let sourceEvents = self!._sourceEvents
               
                switch r.state {
                case .Began:
                    let location = r.locationInView(self)
                    if let i = sourceEvents.indexOf({ $0.frame.contains(location) }) {
                        self!._panEventView = sourceEvents[i]
                    }
                    if let panEventView = self!._panEventView {
                        let snap = panEventView._snap
                        panEventView._animator?.removeBehavior(snap!)
                        let shape: EventShape = (panEventView._recorded.value.element?.shape != nil) ? (panEventView._recorded.value.element?.shape)! : .Another
                        self!._ghostEventView = EventView(recorded: panEventView._recorded, shape: shape, viewController: self!._parentViewController)
                        if let ghostEventView = self!._ghostEventView {
                            ghostEventView.center.y = self!.bounds.height / 2
                            self!.changeGhostColorAndAlpha(ghostEventView, recognizer: r)
                            self!.addSubview(ghostEventView)
                        }
                    }
                case .Changed:
                    if let panEventView = self!._panEventView {
                        
                        let time = Int(r.locationInView(self).x)
                        panEventView.center = r.locationInView(self)
                        panEventView._recorded = RecordedType(time: time, event: panEventView._recorded.value)
                        
                        if let ghostEventView = self!._ghostEventView {
                            self!.changeGhostColorAndAlpha(ghostEventView, recognizer: r)
                            
                            ghostEventView._recorded = panEventView._recorded
                            ghostEventView.center = CGPointMake(CGFloat(ghostEventView._recorded.time), self!.bounds.height / 2)
                        }
                        self!.updateResultTimeline()
                    }
                case .Ended:
                    self!._ghostEventView?.removeFromSuperview()
                    self!._ghostEventView = nil
                    
                    if let panEventView = self!._panEventView {
                        
                        self!.animatorAddBehaviorsToPanEventView(panEventView, recognizer: r, resultTimeline: resultTimeline)
                        
                        panEventView.superview?.bringSubviewToFront(panEventView)
                        self!.bringStopEventViewsToFront(sourceEvents)
                        
                        let time = Int(r.locationInView(self).x)
                        panEventView._recorded = RecordedType(time: time, event: panEventView._recorded.value)
                    }
                    self!._panEventView = nil
                    self!.updateResultTimeline()
                default: break
            }
        }
    }
    
    private func updateResultTimeline() {
        if let secondSourceTimeline = self._sceneView._secondSourceTimeline {
            self._sceneView._resultTimeline.updateEvents((self._sceneView._sourceTimeline._sourceEvents, secondSourceTimeline._sourceEvents))
        } else {
            self._sceneView._resultTimeline.updateEvents((self._sceneView._sourceTimeline._sourceEvents, nil))
        }
    }
    
    func addNextEventToTimeline(time: Int, event: Event<ColoredType>, animator: UIDynamicAnimator!, isEditing: Bool) {
        let v = EventView(recorded: RecordedType(time: time, event: event), shape: (event.element?.shape)!, viewController: _parentViewController)
        if isEditing {
            v.addTapRecognizer()
        }
        addSubview(v)
        v.use(animator, timeLine: self)
        _sourceEvents.append(v)
    }
    
    func addCompletedEventToTimeline(time: Int, animator: UIDynamicAnimator!, isEditing: Bool) {
        let v = EventView(recorded: RecordedType(time: time, event: .Completed), shape: .Another, viewController: _parentViewController)
        if isEditing {
            v.addTapRecognizer()
        }
        addSubview(v)
        v.use(animator, timeLine: self)
        _sourceEvents.append(v)
    }
    
    func addErrorEventToTimeline(time: Int!, animator: UIDynamicAnimator!, isEditing: Bool) {
        let error = NSError(domain: "com.anjlab.RxMarbles", code: 100500, userInfo: nil)
        let v = EventView(recorded: RecordedType(time: time, event: .Error(error)), shape: .Another, viewController: _parentViewController)
        if isEditing {
            v.addTapRecognizer()
        }
        addSubview(v)
        v.use(animator, timeLine: self)
        _sourceEvents.append(v)
    }
    
    private func changeGhostColorAndAlpha(ghostEventView: EventView, recognizer: UIGestureRecognizer) {

        if onDeleteZone(recognizer) == true {
            shakeGhostEventView(ghostEventView)
        } else {
            ghostEventView.layer.removeAllAnimations()
        }
        
        let color: UIColor = onDeleteZone(recognizer) ? .redColor() : .grayColor()
        let alpha: CGFloat = onDeleteZone(recognizer) ? 1.0 : 0.2
        
        switch ghostEventView._recorded.value {
        case .Next:
            ghostEventView.alpha = alpha
            ghostEventView.backgroundColor = color
        case .Completed, .Error:
            ghostEventView.subviews.forEach({ (subView) -> () in
                subView.alpha = alpha
                subView.backgroundColor = color
            })
        }
    }
    
    private func shakeGhostEventView(ghostEventView: EventView) {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        let wobbleAngle: CGFloat = 0.3
        
        let valLeft = NSValue(CATransform3D:CATransform3DMakeRotation(wobbleAngle, 0.0, 0.0, 1.0))
        let valRight = NSValue(CATransform3D:CATransform3DMakeRotation(-wobbleAngle, 0.0, 0.0, 1.0))
        animation.values = [valLeft, valRight]
        
        animation.autoreverses = true
        animation.duration = 0.125
        animation.repeatCount = 10000
        
        if ghostEventView.layer.animationKeys() == nil {
            ghostEventView.layer.addAnimation(animation, forKey: "shake")
        }
    }
    
    private func animatorAddBehaviorsToPanEventView(panEventView: EventView, recognizer: UIGestureRecognizer, resultTimeline: ResultTimelineView) {
        if let animator = panEventView._animator {
            
            let time = Int(recognizer.locationInView(self).x)
            
            if onDeleteZone(recognizer) == true {
                animator.addBehavior(panEventView._gravity!)
                animator.addBehavior(panEventView._removeBehavior!)
                panEventView._removeBehavior?.action = {
                    if let superView = self.superview {
                        if CGRectIntersectsRect(superView.bounds, panEventView.frame) == false {
                            if let index = self._sourceEvents.indexOf(panEventView) {
                                self._sourceEvents.removeAtIndex(index)
                                self.updateResultTimeline()
                            }
                        }
                    }
                }
            } else {
                let snap = panEventView._snap
                snap!.snapPoint.x = CGFloat(time + 10)
                snap!.snapPoint.y = self.center.y
                animator.addBehavior(snap!)
            }
        }
    }
    
    private func onDeleteZone(recognizer: UIGestureRecognizer) -> Bool {
        let sceneHeight = self.superview!.bounds.height
        let y = recognizer.locationInView(self.superview).y
        
        return y / sceneHeight > 0.8
    }
    
    private func bringStopEventViewsToFront(sourceEvents: [EventView]) {
        sourceEvents.forEach({ (eventView) -> () in
            if eventView._recorded.value.isStopEvent == true {
                eventView.superview!.bringSubviewToFront(eventView)
            }
        })
    }
    
    func showAddButton() {
        _addButton = UIButton(type: .ContactAdd)
        self.addSubview(_addButton!)
        removeGestureRecognizer(_longPressGestureRecorgnizer)
    }
    
    func hideAddButton() {
        if _addButton != nil {
            _addButton!.removeFromSuperview()
            _addButton = nil
        }
        addGestureRecognizer(_longPressGestureRecorgnizer)
    }
    
    func addTapRecognizers() {
        _sourceEvents.forEach { (eventView) -> () in
            eventView.addTapRecognizer()
        }
    }
    
    func removeTapRecognizers() {
        _sourceEvents.forEach { (eventView) -> () in
            eventView.removeTapRecognizer()
        }
    }
    
    private func allEventViewsAnimation() {
        _sourceEvents.forEach { eventView in
            eventView.scaleAnimation()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ResultTimelineView: TimelineView {
    
    private var _operator: Operator!
    
    init(frame: CGRect, currentOperator: Operator) {
        super.init(frame: frame)
        _operator = currentOperator
    }
    
    func updateEvents(sourceEvents: (first: [EventView], second: [EventView]?)) {
        let scheduler = TestScheduler(initialClock: 0)
        
        let events = sourceEvents.first.map({ $0._recorded })
        let first = scheduler.createColdObservable(events)
        
        var second: TestableObservable<ColoredType>? = nil
        if let s = sourceEvents.second {
            let secondEvents = s.map({ $0._recorded })
            second = scheduler.createColdObservable(secondEvents)
        }
        
        let o = _operator.map((first, second), scheduler: scheduler)
        var res: TestableObserver<ColoredType>?
        
        res = scheduler.start(0, subscribed: 0, disposed: Int(frame.width)) {
            return o
        }
        
        addEventsToTimeline(res!.events)
    }
    
    func addEventsToTimeline(events: [RecordedType]) {
        _sourceEvents.forEach { (eventView) -> () in
            eventView.removeFromSuperview()
        }

        _sourceEvents.removeAll()
        
        events.forEach { (event) -> () in
            let shape: EventShape = (event.value.element?.shape != nil) ? (event.value.element?.shape)! : .Another
            let eventView = EventView(recorded: RecordedType(time: event.time, event: event.value), shape: shape, viewController: _parentViewController)
            eventView.center.y = self.bounds.height / 2
            _sourceEvents.append(eventView)
            addSubview(eventView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class SceneView: UIView {
    var animator: UIDynamicAnimator?
    var _sourceTimeline: SourceTimelineView!
    var _secondSourceTimeline: SourceTimelineView!
    var _resultTimeline: ResultTimelineView!
    
    init() {
        super.init(frame: CGRectZero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {
    var _currentOperator = Operator.Delay
    private var _operatorTableViewController: OperatorTableViewController?
    private var _sceneView: SceneView!
    private var _isEditing: Bool = false {
        didSet {
            if _isEditing {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "enableEditing")
                self.navigationItem.setHidesBackButton(true, animated: true)
                UIView.animateWithDuration(0.3, animations: { _ in
                    self._sceneView._resultTimeline.alpha = 0.5
                })
                _sceneView._sourceTimeline.addTapRecognizers()
                _sceneView._sourceTimeline.showAddButton()
                _sceneView._sourceTimeline.allEventViewsAnimation()
                _sceneView._sourceTimeline._addButton!.addTarget(self, action: "addElementToTimeline:", forControlEvents: .TouchUpInside)
                if _currentOperator.multiTimelines {
                    _sceneView._secondSourceTimeline.addTapRecognizers()
                    _sceneView._secondSourceTimeline.showAddButton()
                    _sceneView._secondSourceTimeline.allEventViewsAnimation()
                    _sceneView._secondSourceTimeline._addButton!.addTarget(self, action: "addElementToTimeline:", forControlEvents: .TouchUpInside)
                }
            } else {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "enableEditing")
                self.navigationItem.setHidesBackButton(false, animated: true)
                UIView.animateWithDuration(0.3, animations: { _ in
                    self._sceneView._resultTimeline.alpha = 1.0
                })
                _sceneView._sourceTimeline.removeTapRecognizers()
                _sceneView._sourceTimeline.hideAddButton()
                _sceneView._sourceTimeline.allEventViewsAnimation()
                if _currentOperator.multiTimelines {
                    _sceneView._secondSourceTimeline.removeTapRecognizers()
                    _sceneView._secondSourceTimeline.hideAddButton()
                    _sceneView._secondSourceTimeline.allEventViewsAnimation()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        navigationController?.navigationBar.topItem!.backBarButtonItem = UIBarButtonItem(title: _currentOperator.description, style: UIBarButtonItemStyle.Plain, target: self, action: "backToOperatorView")
    }
    
    override func viewWillAppear(animated: Bool) {
        setupSceneView()
        _isEditing = false
    }
    
    private func setupSceneView() {
        if _sceneView != nil {
            _sceneView.removeFromSuperview()
        }
        _sceneView = SceneView()
        view.addSubview(_sceneView)
        _sceneView.frame = view.frame
        _sceneView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[sceneView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["sceneView" : _sceneView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[sceneView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["sceneView" : _sceneView]))
        
        _sceneView.animator = UIDynamicAnimator(referenceView: _sceneView)
        
        let width = _sceneView.frame.width - 20
        
        let resultTimeline = ResultTimelineView(frame: CGRectMake(10, 0, width, 40), currentOperator: _currentOperator)
        resultTimeline.center.y = 200
        _sceneView.addSubview(resultTimeline)
        _sceneView._resultTimeline = resultTimeline
        
        let sourceTimeLine = SourceTimelineView(frame: CGRectMake(10, 0, width, 40), resultTimeline: resultTimeline)
        sourceTimeLine._parentViewController = self
        sourceTimeLine._sceneView = _sceneView
        sourceTimeLine.center.y = 120
        _sceneView.addSubview(sourceTimeLine)
        _sceneView._sourceTimeline = sourceTimeLine
        
        for t in 1..<4 {
            let time = t * 40
            let event = Event.Next(ColoredType(value: String(randomNumber()), color: RXMUIKit.randomColor(), shape: .Circle))
            sourceTimeLine.addNextEventToTimeline(time, event: event, animator: self._sceneView.animator, isEditing: _isEditing)
        }
        sourceTimeLine.addCompletedEventToTimeline(150, animator: self._sceneView.animator, isEditing: _isEditing)
        
        if _currentOperator.multiTimelines {
            resultTimeline.center.y = 280
            let secondSourceTimeline = SourceTimelineView(frame: CGRectMake(10, 0, width, 40), resultTimeline: resultTimeline)
            secondSourceTimeline._parentViewController = self
            secondSourceTimeline._sceneView = _sceneView
            secondSourceTimeline.center.y = 200
            _sceneView.addSubview(secondSourceTimeline)
            _sceneView._secondSourceTimeline = secondSourceTimeline
            
            for t in 1..<3 {
                let time = t * 40
                let event = Event.Next(ColoredType(value: String(randomNumber()), color: RXMUIKit.randomColor(), shape: .RoundedRect))
                secondSourceTimeline.addNextEventToTimeline(time, event: event, animator: self._sceneView.animator, isEditing: _isEditing)
            }
            
            secondSourceTimeline.addCompletedEventToTimeline(110, animator: self._sceneView.animator, isEditing: _isEditing)
        }
        
        sourceTimeLine.updateResultTimeline()
    }
    
    func enableEditing() {
        _isEditing = !_isEditing
    }
    
    func addElementToTimeline(sender: UIButton) {
        if let timeline: SourceTimelineView = sender.superview as? SourceTimelineView {
            var time = Int(timeline.bounds.size.width / 2.0)
            
            let elementSelector = UIAlertController(title: "Add event", message: nil, preferredStyle: .ActionSheet)
            
            let nextAction = UIAlertAction(title: "Next", style: .Default) { (action) -> Void in
                let shape: EventShape = (timeline == self._sceneView._sourceTimeline) ? .Circle : .RoundedRect
                let event = Event.Next(ColoredType(value: String(self.randomNumber()), color: RXMUIKit.randomColor(), shape: shape))
                timeline.addNextEventToTimeline(time, event: event, animator: self._sceneView.animator, isEditing: self._isEditing)
                timeline.updateResultTimeline()
            }
            let completedAction = UIAlertAction(title: "Completed", style: .Default) { (action) -> Void in
                if let t = timeline.maxNextTime() {
                    time = t + 20
                } else {
                    time = Int(self._sceneView._sourceTimeline.bounds.size.width - 60.0)
                }
                timeline.addCompletedEventToTimeline(time, animator: self._sceneView.animator, isEditing: self._isEditing)
                timeline.updateResultTimeline()
            }
            let errorAction = UIAlertAction(title: "Error", style: .Default) { (action) -> Void in
                timeline.addErrorEventToTimeline(time, animator: self._sceneView.animator, isEditing: self._isEditing)
                timeline.updateResultTimeline()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in }
            
            elementSelector.addAction(nextAction)
            let sourceEvents: [EventView] = timeline._sourceEvents
            if sourceEvents.indexOf({ $0.isCompleted == true }) == nil {
                elementSelector.addAction(completedAction)
            }
            elementSelector.addAction(errorAction)
            elementSelector.addAction(cancelAction)
            
            presentViewController(elementSelector, animated: true) { () -> Void in }
        }
    }
    
    func backToOperatorView() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func randomNumber() -> Int {
        return Int(arc4random_uniform(10) + 1)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
                self._sceneView._resultTimeline._sourceEvents.forEach({ (eventView) -> () in
                    eventView.removeFromSuperview()
                })
            }) { (context) -> Void in
//                let width = self.view.frame.width
//                let height = self.view.frame.height
//                let koef = width / height
//                time * koef
                if let sourceTimeline = self._sceneView._sourceTimeline {
                    sourceTimeline.updateResultTimeline()
                }
        }
    }
}