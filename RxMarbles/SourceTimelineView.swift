//
//  SourceTimelineView.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 21.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SourceTimelineView: TimelineView {
    
    private let _longPressGestureRecorgnizer = UILongPressGestureRecognizer()
    private var _panEventView: EventView?
    private var _ghostEventView: EventView?
    
    weak var sceneView: SceneView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, scene: SceneView) {
        super.init(frame: frame)
        userInteractionEnabled = true
        clipsToBounds = false
        sceneView = scene
        
        _longPressGestureRecorgnizer.minimumPressDuration = 0.0
        
        addGestureRecognizer(_longPressGestureRecorgnizer)
        
        _ = _longPressGestureRecorgnizer
            .rx_event
            .subscribeNext { [unowned self] r in self._handleLongPressGestureRecognizer(r) }
    }
    
    private func _handleLongPressGestureRecognizer(r: UIGestureRecognizer) {
        let location = r.locationInView(self)
        
        switch r.state {
        case .Began:
            if let i = _sourceEvents.indexOf({ $0.frame.contains(location) }) {
                _panEventView = _sourceEvents[i]
            }
            if let panEventView = _panEventView {
                panEventView._animator?.removeBehavior(panEventView.snap!)
                let shape: EventShape = (panEventView._recorded.value.element?.shape != nil) ? (panEventView._recorded.value.element?.shape)! : .Another
                self._ghostEventView = EventView(recorded: panEventView._recorded, shape: shape)
                if let ghostEventView = self._ghostEventView {
                    ghostEventView.center.y = self.bounds.height / 2
                    self.changeGhostColorAndAlpha(ghostEventView, recognizer: r)
                    self.addSubview(ghostEventView)
                    self.sceneView.showTrashView()
                }
            }
        case .Changed:
            if let panEventView = self._panEventView {
                let time = Int(location.x)
                panEventView.center = location
                panEventView._recorded = RecordedType(time: time, event: panEventView._recorded.value)
                
                if let ghostEventView = self._ghostEventView {
                    changeGhostColorAndAlpha(ghostEventView, recognizer: r)
                    
                    ghostEventView._recorded = panEventView._recorded
                    ghostEventView.center = CGPointMake(CGFloat(ghostEventView._recorded.time), self.bounds.height / 2)
                }
                self.updateResultTimeline()
            }
        case .Ended:
            _ghostEventView?.removeFromSuperview()
            _ghostEventView = nil
            
            if let panEventView = _panEventView {
                animatorAddBehaviorsToPanEventView(panEventView, recognizer: r, resultTimeline: sceneView.resultTimeline)
                
                panEventView.superview?.bringSubviewToFront(panEventView)
                bringStopEventViewsToFront(_sourceEvents)
                
                let time = Int(r.locationInView(self).x)
                panEventView._recorded = RecordedType(time: time, event: panEventView._recorded.value)
            }
            _panEventView = nil
            updateResultTimeline()
            sceneView.hideTrashView()
        default: break
        }
    }
    
    func updateResultTimeline() {
        if let secondSourceTimeline = sceneView.secondSourceTimeline {
            sceneView.resultTimeline.updateEvents((sceneView.sourceTimeline._sourceEvents, secondSourceTimeline._sourceEvents))
        } else {
            sceneView.resultTimeline.updateEvents((sceneView.sourceTimeline._sourceEvents, nil))
        }
    }
    
    func addNextEventToTimeline(time: Int, event: Event<ColoredType>, animator: UIDynamicAnimator!, isEditing: Bool) {
        let v = EventView(recorded: RecordedType(time: time, event: event), shape: (event.element?.shape)!)
        if isEditing {
            v.addTapRecognizer()
        }
        addSubview(v)
        v.use(animator, timeLine: self)
        _sourceEvents.append(v)
    }
    
    func addCompletedEventToTimeline(time: Int, animator: UIDynamicAnimator!, isEditing: Bool) {
        let v = EventView(recorded: RecordedType(time: time, event: .Completed), shape: .Another)
        if isEditing {
            v.addTapRecognizer()
        }
        addSubview(v)
        v.use(animator, timeLine: self)
        _sourceEvents.append(v)
    }
    
    func addErrorEventToTimeline(time: Int!, animator: UIDynamicAnimator!, isEditing: Bool) {
        let v = EventView(recorded: RecordedType(time: time, event: .Error(Error.CantParseStringToInt)), shape: .Another)
        if isEditing {
            v.addTapRecognizer()
        }
        addSubview(v)
        v.use(animator, timeLine: self)
        _sourceEvents.append(v)
    }
    
     func changeGhostColorAndAlpha(ghostEventView: EventView, recognizer: UIGestureRecognizer) {
        if onDeleteZone(recognizer) == true {
            ghostEventView.shake()
            sceneView.trashView.shake()
            sceneView.trashView.alpha = 0.5
        } else {
            ghostEventView.stopAnimations()
            sceneView.trashView.stopAnimations()
            sceneView.trashView.alpha = 0.2
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
    
    private func animatorAddBehaviorsToPanEventView(panEventView: EventView, recognizer: UIGestureRecognizer, resultTimeline: ResultTimelineView) {
        if let animator = panEventView._animator {
            animator.removeAllBehaviors()
            let time = Int(recognizer.locationInView(self).x)
            
            if onDeleteZone(recognizer) == true {
                panEventView.hideWithCompletion({ _ in
                    if let index = self._sourceEvents.indexOf(panEventView) {
                        self._sourceEvents.removeAtIndex(index)
                        self.updateResultTimeline()
                    }
                })
            } else {
                let snap = panEventView.snap
                snap!.snapPoint.x = CGFloat(time + 10)
                snap!.snapPoint.y = center.y
                animator.addBehavior(snap!)
            }
        }
    }
    
    private func onDeleteZone(recognizer: UIGestureRecognizer) -> Bool {
        let trash = sceneView.trashView
        let loc = recognizer.locationInView(superview)
        let eventViewFrame = CGRectMake(loc.x - 19, loc.y - 19, 38, 38)
        if CGRectIntersectsRect(trash.frame, eventViewFrame) {
            return true
        }
        return false
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
        addSubview(_addButton!)
        removeGestureRecognizer(_longPressGestureRecorgnizer)
    }
    
    func hideAddButton() {
        _addButton?.removeFromSuperview()
        _addButton = nil
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
    
    func allEventViewsAnimation() {
        _sourceEvents.forEach { eventView in
            eventView.scaleAnimation()
        }
    }
}