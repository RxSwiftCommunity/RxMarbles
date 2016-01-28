//
//  ResultTimelineView.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 21.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ResultTimelineView: TimelineView {
    
    private var _operator: Operator!
    private weak var _sceneView: SceneView!
    private var _disposeBag = DisposeBag()
    
    var subject = PublishSubject<Void>()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init(frame: CGRect, rxOperator: Operator, sceneView: SceneView) {
        super.init(frame: frame)
        _operator = rxOperator
        _sceneView = sceneView
        
        subject
            .debounce(0.009, scheduler: MainScheduler.instance)
            .subscribeNext { [unowned self] _ in
                self.updateEvents(
                (
                    first: self._sceneView.sourceTimeline.sourceEvents,
                    second: self._sceneView.secondSourceTimeline?.sourceEvents
                )
            )
        }
        .addDisposableTo(_disposeBag)
    }
    
    private func updateEvents(sourceEvents: (first: [EventView], second: [EventView]?)) {
        let scheduler = TestScheduler(initialClock: 0)
        
        let events = sourceEvents.first.map({ $0.recorded })
        let first = scheduler.createColdObservable(events)
        
        var second: TestableObservable<ColoredType>? = nil
        if _operator.multiTimelines {
            if let s = sourceEvents.second {
                let secondEvents = s.map({ $0.recorded })
                second = scheduler.createColdObservable(secondEvents)
            }
        }
        
        let o = _operator.map((first, second), scheduler: scheduler)
        
        var res: TestableObserver<ColoredType>?
        res = scheduler.start(0, subscribed: 0, disposed: 1001) {
            return o
        }
        
        addEventsToTimeline(res!.events)
    }
    
    func addEventsToTimeline(events: [RecordedType]) {
        sourceEvents.forEach { $0.removeFromSuperview() }
        var newSourceEvents = [EventView]()
        events.forEach {
            switch $0.value {
            case .Next:
                if let index = sourceEvents.indexOf({ $0.isNext }) {
                    let eventView = reuseEventView(index, recorded: $0)
                    eventView.refreshColorAndValue()
                    newSourceEvents.append(eventView)
                } else {
                    newSourceEvents.append(newEventView(RecordedType(time: $0.time, event: $0.value)))
                }
            case .Completed:
                if let index = sourceEvents.indexOf({ $0.isCompleted }) {
                    newSourceEvents.append(reuseEventView(index, recorded: RecordedType(time: $0.time, event: .Completed)))
                } else {
                    newSourceEvents.append(newEventView(RecordedType(time: $0.time, event: .Completed)))
                }
            case .Error:
                if let index = sourceEvents.indexOf({ $0.isError }) {
                    newSourceEvents.append(reuseEventView(index, recorded: RecordedType(time: $0.time, event: .Error(Error.CantParseStringToInt))))
                } else {
                    newSourceEvents.append(newEventView(RecordedType(time: $0.time, event: .Error(Error.CantParseStringToInt))))
                }
            }
        }
        
        sourceEvents = newSourceEvents
    }
    
    private func reuseEventView(index: Int, recorded: RecordedType) -> EventView {
        let reuseEventView = sourceEvents[index]
        sourceEvents.removeAtIndex(index)
        reuseEventView.recorded = RecordedType(time: recorded.time, event: recorded.value)
        reuseEventView.center.x = xPositionByTime(recorded.time)
        reuseEventView.center.y = bounds.height / 2
        addSubview(reuseEventView)
        return reuseEventView
    }
    
    private func newEventView(recorded: RecordedType) -> EventView {
        let newEventView = EventView(recorded: recorded)
        newEventView.center.x = xPositionByTime(recorded.time)
        newEventView.center.y = bounds.height / 2
        addSubview(newEventView)
        return newEventView
    }
    
    override func setEditing() {
        super.setEditing()
        UIView.animateWithDuration(0.3) { _ in
            self.alpha = self.editing ? 0.5 : 1.0
        }
        if !editing {
            sourceEvents.forEach({ $0.scaleAnimation() })
        }
    }
}