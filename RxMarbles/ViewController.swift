//
//  ViewController.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 06.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit
import SpriteKit
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class TimelineView: UIView {
    var _sourceEvents = [EventView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let timeArrow = UIImageView(image: TimelineImage.timeLine)
        timeArrow.frame = CGRectMake(0, 0, self.bounds.width, TimelineImage.timeLine.size.height)
        timeArrow.center.y = self.center.y
        self.addSubview(timeArrow)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SourceTimelineView: TimelineView {
    
    private let _panGestureRecognizer = UIPanGestureRecognizer()
    private var _panEventView: EventView?
    private var _ghostEventView: EventView?
    
    init(frame: CGRect, resultTimeline: ResultTimelineView) {
        super.init(frame: frame)
        userInteractionEnabled = true
        clipsToBounds = false
        
        addGestureRecognizer(_panGestureRecognizer)
        
        _ = _panGestureRecognizer.rx_event
            .subscribeNext { [weak self] r in
                
                let sourceEvents = self!._sourceEvents
                
                if r.state == .Began {
                    let location = r.locationInView(self)

                    if let i = sourceEvents.indexOf({ $0.frame.contains(location) }) {
                        self!._panEventView = sourceEvents[i]
                    }
                    if let panEventView = self!._panEventView {
                        let snap = panEventView._snap
                        panEventView._animator?.removeBehavior(snap!)
                    }
                }
                
                if r.state == .Changed {
                    if self!._ghostEventView != nil {
                        self!._ghostEventView?.removeFromSuperview()
                        self!._ghostEventView = nil
                    }
                    
                    if let panEventView = self!._panEventView {
                        self!._ghostEventView = EventView(recorded: panEventView._recorded)
                        
                        if let ghostEventView = self!._ghostEventView {
                            ghostEventView.alpha = 0.2
                            let sceneHeight = self!.superview!.bounds.height
                            let y = r.locationInView(self!.superview).y
                            
                            let color: UIColor = y / sceneHeight > 0.8 ? .redColor() : .grayColor()
                            switch ghostEventView._recorded.value {
                            case .Next:
                                ghostEventView.backgroundColor = color
                            case .Completed, .Error:
                                ghostEventView.subviews.forEach({ (subView) -> () in
                                    subView.backgroundColor = color
                                })
                            }
                            
                            ghostEventView.center.y = self!.bounds.height / 2
                            self!.addSubview(ghostEventView)
                        }
                        
                        let time = Int(r.locationInView(self).x)
                        panEventView.center = r.locationInView(self)
                        panEventView._recorded = RecordedType(time: time, event: panEventView._recorded.value)
                        resultTimeline.updateEvents(sourceEvents)
                    }
                }
                
                if r.state == .Ended {
                    if self!._ghostEventView != nil {
                        self!._ghostEventView?.removeFromSuperview()
                        self!._ghostEventView = nil
                    }
                    
                    if let panEventView = self!._panEventView {
                        
                        let sceneHeight = self!.superview!.bounds.height
                        let y = r.locationInView(self!.superview).y
                        let time = Int(r.locationInView(self).x)
                        
                        let snap = panEventView._snap
                        snap!.snapPoint.x = CGFloat(time + 10)
                        snap!.snapPoint.y = self!.center.y
                        
                        if let animator = panEventView._animator {
                            if y / sceneHeight > 0.8 {
                                animator.addBehavior(panEventView._gravity!)
                                animator.addBehavior(panEventView._removeBehavior!)
                                panEventView._removeBehavior?.action = {
                                    if let superView = self!.superview {
                                        if CGRectIntersectsRect(superView.bounds, panEventView.frame) == false {
                                            if let index = self!._sourceEvents.indexOf(panEventView) {
                                                self!._sourceEvents.removeAtIndex(index)
                                                resultTimeline.updateEvents(self!._sourceEvents)
                                                print("removed")
                                            }
                                        }
                                    }
                                }
                            } else {
                                animator.addBehavior(snap!)
                            }
                        }
                        
                        panEventView.superview?.bringSubviewToFront(panEventView)
                        sourceEvents.forEach({ (eventView) -> () in
                            switch eventView._recorded.value {
                            case .Completed:
                                eventView.superview!.bringSubviewToFront(eventView)
                            case .Error:
                                eventView.superview!.bringSubviewToFront(eventView)
                            default:
                                break
                            }
                        })
                        panEventView._recorded = RecordedType(time: time, event: panEventView._recorded.value)
                    }
                    self!._panEventView = nil
                    resultTimeline.updateEvents(sourceEvents)
                }
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
    
    func updateEvents(sourceEvents: [EventView]) {
        let scheduler = TestScheduler(initialClock: 0)
        let events = sourceEvents.map({ $0._recorded })
        let t = scheduler.createColdObservable(events)
        let o = _operator.map(t.asObservable(), scheduler: scheduler)
        let res = scheduler.start(0, subscribed: 0, disposed: Int(frame.width)) {
            return o
        }
        
        addEventsToTimeline(res.events)
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
        }

        _sourceEvents.forEach { (eventView) -> () in
            self.addSubview(eventView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class SceneView: UIView {
    var animator: UIDynamicAnimator?
    var _sourceTimeline: TimelineView!
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
        
        if _sceneView != nil {
            _sceneView.removeFromSuperview()
        }
        
        _sceneView = SceneView()
        setupSceneView()
    }
    
    private func setupSceneView() {
        view.addSubview(_sceneView)
        _sceneView.frame = view.frame
        
        _sceneView.animator = UIDynamicAnimator(referenceView: _sceneView)
        
        let resultTimeline = ResultTimelineView(frame: CGRectMake(10, 0, _sceneView.bounds.width - 20, 40), currentOperator: _currentOperator)
        resultTimeline.center.y = 200
        _sceneView.addSubview(resultTimeline)
        _sceneView._resultTimeline = resultTimeline
        
        let sourceTimeLine = SourceTimelineView(frame: CGRectMake(10, 0, _sceneView.bounds.width - 20, 40), resultTimeline: resultTimeline)
        sourceTimeLine.center.y = 120
        _sceneView.addSubview(sourceTimeLine)
        _sceneView._sourceTimeline = sourceTimeLine
        
        for t in 1..<6 {
            let time = t * 50
            let event = Event.Next(ColoredType(value: t, color: RXMUIKit.randomColor()))
            let v = EventView(recorded: RecordedType(time: time, event: event))
            sourceTimeLine.addSubview(v)
            v.use(_sceneView.animator, timeLine: sourceTimeLine)
            sourceTimeLine._sourceEvents.append(v)
        }
        
        let v = EventView(recorded: RecordedType(time: Int(sourceTimeLine.bounds.size.width - 60.0), event: .Completed))
        sourceTimeLine.addSubview(v)
        v.use(_sceneView.animator, timeLine: sourceTimeLine)
        sourceTimeLine._sourceEvents.append(v)
        
        let error = NSError(domain: "com.anjlab.RxMarbles", code: 100500, userInfo: nil)
        let e = EventView(recorded: RecordedType(time: Int(sourceTimeLine.bounds.size.width - 30.0), event: .Error(error)))
        sourceTimeLine.addSubview(e)
        e.use(_sceneView.animator, timeLine: sourceTimeLine)
        sourceTimeLine._sourceEvents.append(e)
        
        resultTimeline.updateEvents(sourceTimeLine._sourceEvents)
    }
    
    func addElement() {
        let sourceTimeline = _sceneView._sourceTimeline
        let resultTimeline = _sceneView._resultTimeline
        let time = Int(sourceTimeline.bounds.size.width / 2.0)
        
        let elementSelector = UIAlertController(title: "Add event", message: nil, preferredStyle: .ActionSheet)
        
        let nextAction = UIAlertAction(title: "Next", style: .Default) { (action) -> Void in
            let event = Event.Next(ColoredType(value: 1, color: RXMUIKit.randomColor()))
            let v = EventView(recorded: RecordedType(time: time, event: event))
            sourceTimeline.addSubview(v)
            v.use(self._sceneView.animator, timeLine: sourceTimeline)
            sourceTimeline._sourceEvents.append(v)
            resultTimeline.updateEvents(sourceTimeline._sourceEvents)
        }
        let completedAction = UIAlertAction(title: "Completed", style: .Default) { (action) -> Void in
            let v = EventView(recorded: RecordedType(time: time, event: .Completed))
            sourceTimeline.addSubview(v)
            v.use(self._sceneView.animator, timeLine: sourceTimeline)
            sourceTimeline._sourceEvents.append(v)
            resultTimeline.updateEvents(sourceTimeline._sourceEvents)
        }
        let errorAction = UIAlertAction(title: "Error", style: .Default) { (action) -> Void in
            let error = NSError(domain: "com.anjlab.RxMarbles", code: 100500, userInfo: nil)
            let e = EventView(recorded: RecordedType(time: time, event: .Error(error)))
            sourceTimeline.addSubview(e)
            e.use(self._sceneView.animator, timeLine: sourceTimeline)
            sourceTimeline._sourceEvents.append(e)
            resultTimeline.updateEvents(sourceTimeline._sourceEvents)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in }
        
        elementSelector.addAction(nextAction)
        elementSelector.addAction(completedAction)
        elementSelector.addAction(errorAction)
        elementSelector.addAction(cancelAction)
        
        presentViewController(elementSelector, animated: true) { () -> Void in }
    }
    
    func showOperatorView() {
        _operatorTableViewController = OperatorTableViewController()
        _operatorTableViewController?.selectedOperator = _currentOperator
        _operatorTableViewController?.title = "Select Operator"
        navigationController?.pushViewController(_operatorTableViewController!, animated: true)
    }
}