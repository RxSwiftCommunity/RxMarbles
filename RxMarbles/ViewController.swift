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
    var value: Int
    var color: UIColor
}

struct TimelineImage {
    static var timeLine: UIImage { return UIImage(named: "timeLine")! }
    static var cross: UIImage { return UIImage(named: "cross")! }
}

func ==(lhs: ColoredType, rhs: ColoredType) -> Bool {
    return lhs.value == rhs.value && lhs.color == rhs.color
}

typealias RecordedType = Recorded<Event<ColoredType>>

class EventView: UILabel {
    private var _recorded = RecordedType(time: 0, event: .Completed)
    private weak var _animator: UIDynamicAnimator? = nil
    private var _snap: UISnapBehavior? = nil
    private var _gravity: UIGravityBehavior? = nil
    private var _removeBehavior: UIDynamicItemBehavior? = nil
    private weak var _timeLine: UIView?
    
    init(recorded: RecordedType) {
        
        switch recorded.value {
        case let .Next(v):
            super.init(frame: CGRectMake(0, 0, 38, 38))
            center = CGPointMake(CGFloat(recorded.time), bounds.height)
            layer.cornerRadius = bounds.width / 2.0
            clipsToBounds = true
            backgroundColor = v.color
            layer.borderColor = UIColor.lightGrayColor().CGColor
            layer.borderWidth = 0.5
            textAlignment = .Center
            font = UIFont(name: "", size: 17.0)
            textColor = .whiteColor()
            if let value = recorded.value.element?.value {
                text = String(value)
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
    }
    
    func use(animator: UIDynamicAnimator?, timeLine: UIView?) {
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class TimelineView: UIView {
    var _sourceEvents = [EventView]()
    let _timeArrow = UIImageView(image: TimelineImage.timeLine)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(_timeArrow)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frame = CGRectMake(10, frame.origin.y, (superview?.bounds.size.width)! - 20, 40)
        _timeArrow.frame = CGRectMake(0, 16, frame.width, TimelineImage.timeLine.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
                        self!._ghostEventView = EventView(recorded: panEventView._recorded)
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
        switch _operator! {
        case .Sample:
            res = scheduler.start({ first.sample(second!) })
        case .Amb:
            res = scheduler.start({ first.amb(second!) })
        default:
            res = scheduler.start(0, subscribed: 0, disposed: Int(frame.width)) {
                return o
            }
        }
        
        addEventsToTimeline(res!.events)
    }
    
    func addEventsToTimeline(events: [RecordedType]) {
        _sourceEvents.forEach { (eventView) -> () in
            eventView.removeFromSuperview()
        }

        _sourceEvents.removeAll()
        
        events.forEach { (event) -> () in
            let eventView = EventView(recorded: RecordedType(time: event.time, event: event.value))
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
    private var _currentOperator = Operator.Delay
    private var _operatorTableViewController: OperatorTableViewController?
    private var _sceneView: SceneView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addElement")
        self.navigationItem.leftBarButtonItem = addButton
        
        let operatorButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "showOperatorView")
        self.navigationItem.rightBarButtonItem = operatorButton
    }
    
    override func viewWillAppear(animated: Bool) {
        if let newOperator = _operatorTableViewController?.selectedOperator {
            _currentOperator = newOperator
        }
        title = _currentOperator.description
        
        setupSceneView()
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
        sourceTimeLine._sceneView = _sceneView
        sourceTimeLine.center.y = 120
        _sceneView.addSubview(sourceTimeLine)
        _sceneView._sourceTimeline = sourceTimeLine
        
        for t in 1..<4 {
            let time = t * 40
            let event = Event.Next(ColoredType(value: randomNumber(), color: RXMUIKit.randomColor()))
            addNextEventToTimeline(time, event: event, timeline: sourceTimeLine)
        }
        
        addCompletedEventToTimeline(150, timeline: sourceTimeLine)
        
        if _currentOperator.multiTimelines {
            resultTimeline.center.y = 280
            let secondSourceTimeline = SourceTimelineView(frame: CGRectMake(10, 0, width, 40), resultTimeline: resultTimeline)
            secondSourceTimeline._sceneView = _sceneView
            secondSourceTimeline.center.y = 200
            _sceneView.addSubview(secondSourceTimeline)
            _sceneView._secondSourceTimeline = secondSourceTimeline
            
            for t in 1..<3 {
                let time = t * 40
                let event = Event.Next(ColoredType(value: t, color: RXMUIKit.randomColor()))
                addNextEventToTimeline(time, event: event, timeline: secondSourceTimeline)
            }
            
            addCompletedEventToTimeline(110, timeline: secondSourceTimeline)
        }
        
        sourceTimeLine.updateResultTimeline()
    }
    
    func addElement() {
        let sourceTimeline = _sceneView._sourceTimeline
        var time = Int(sourceTimeline.bounds.size.width / 2.0)
        
        let elementSelector = UIAlertController(title: "Add event", message: nil, preferredStyle: .ActionSheet)
        
        let nextAction = UIAlertAction(title: "Next", style: .Default) { (action) -> Void in
            let event = Event.Next(ColoredType(value: self.randomNumber(), color: RXMUIKit.randomColor()))
            self.addNextEventToTimeline(time, event: event, timeline: sourceTimeline)
            sourceTimeline.updateResultTimeline()
        }
        let completedAction = UIAlertAction(title: "Completed", style: .Default) { (action) -> Void in
            if let t = self.maxNextTime(sourceTimeline._sourceEvents) {
                time = t + 20
            } else {
                time = Int(self._sceneView._sourceTimeline.bounds.size.width - 60.0)
            }
            self.addCompletedEventToTimeline(time, timeline: sourceTimeline)
            sourceTimeline.updateResultTimeline()
        }
        let errorAction = UIAlertAction(title: "Error", style: .Default) { (action) -> Void in
            self.addErrorEventToTimeline(time, timeline: sourceTimeline)
            sourceTimeline.updateResultTimeline()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in }
        
        elementSelector.addAction(nextAction)
        let sourceEvents: [EventView] = sourceTimeline._sourceEvents
        if sourceEvents.indexOf({ $0.isCompleted == true }) == nil {
            elementSelector.addAction(completedAction)
        }
        elementSelector.addAction(errorAction)
        elementSelector.addAction(cancelAction)
        
        presentViewController(elementSelector, animated: true) { () -> Void in }
    }
    
    private func addNextEventToTimeline(time: Int, event: Event<ColoredType>, timeline: TimelineView) {
        let v = EventView(recorded: RecordedType(time: time, event: event))
        timeline.addSubview(v)
        v.use(_sceneView.animator, timeLine: timeline)
        timeline._sourceEvents.append(v)
    }
    
    private func addCompletedEventToTimeline(time: Int, timeline: TimelineView) {
        let v = EventView(recorded: RecordedType(time: time, event: .Completed))
        timeline.addSubview(v)
        v.use(_sceneView.animator, timeLine: timeline)
        timeline._sourceEvents.append(v)
    }
    
    private func addErrorEventToTimeline(time: Int, timeline: TimelineView) {
        let error = NSError(domain: "com.anjlab.RxMarbles", code: 100500, userInfo: nil)
        let v = EventView(recorded: RecordedType(time: time, event: .Error(error)))
        timeline.addSubview(v)
        v.use(self._sceneView.animator, timeLine: timeline)
        timeline._sourceEvents.append(v)
    }
    
    private func maxNextTime(sourceEvents: [EventView]!) -> Int? {
        var times = Array<Int>()
        sourceEvents.forEach { (eventView) -> () in
            if eventView.isNext {
                times.append(eventView._recorded.time)
            }
        }
        return times.maxElement()
    }
    
    func showOperatorView() {
        _operatorTableViewController = OperatorTableViewController()
        _operatorTableViewController?.selectedOperator = _currentOperator
        _operatorTableViewController?.title = "Select Operator"
        navigationController?.pushViewController(_operatorTableViewController!, animated: true)
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