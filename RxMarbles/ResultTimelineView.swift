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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init(frame: CGRect, rxOperator: Operator) {
        super.init(frame: frame)
        _operator = rxOperator
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
        
        res = scheduler.start(0, subscribed: 0, disposed: 1000) {
            return o
        }
        
        addEventsToTimeline(res!.events)
    }
    
    func addEventsToTimeline(events: [RecordedType]) {
        sourceEvents.forEach { $0.removeFromSuperview() }
        sourceEvents.removeAll()
        
        events.forEach {
            let eventView = EventView(recorded: RecordedType(time: $0.time, event: $0.value))
            eventView.center.x = xPositionByTime($0.time)
            eventView.center.y = bounds.height / 2
            sourceEvents.append(eventView)
            addSubview(eventView)
        }
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