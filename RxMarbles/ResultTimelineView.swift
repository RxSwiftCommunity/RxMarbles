//
//  ResultTimelineView.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 21.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit

class ResultTimelineView: TimelineView {
    
    private var _operator: Operator!
    
    init(frame: CGRect, currentOperator: Operator) {
        super.init(frame: frame)
        _operator = currentOperator
    }
    
    func updateEvents(sourceEvents: (first: [EventView], second: [EventView]?)) {
        let scheduler = TestScheduler(initialClock: 0)
        
        let events = sourceEvents.first.map({ $0.recorded })
        let first = scheduler.createColdObservable(events)
        
        var second: TestableObservable<ColoredType>? = nil
        if let s = sourceEvents.second {
            let secondEvents = s.map({ $0.recorded })
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
        sourceEvents.forEach { (eventView) -> () in
            eventView.removeFromSuperview()
        }
        
        sourceEvents.removeAll()
        
        events.forEach { (event) -> () in
            let shape: EventShape = (event.value.element?.shape != nil) ? (event.value.element?.shape)! : .Another
            let eventView = EventView(recorded: RecordedType(time: event.time, event: event.value), shape: shape)
            eventView.center.y = bounds.height / 2
            sourceEvents.append(eventView)
            addSubview(eventView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}