//
//  ResultTimelineView.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 21.01.16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Device

class ResultSequenceView: SequenceView {
    
    private var _operator: Operator!
    private weak var _sceneView: SceneView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init(frame: CGRect, rxOperator: Operator, sceneView: SceneView) {
        super.init(frame: frame)
        _operator = rxOperator
        _sceneView = sceneView
        
        subject
            .debounce(debounce, scheduler: MainScheduler.instance)
            .subscribe { [unowned self] _ in
                self.updateEvents(
                (
                    a: self._sceneView.sourceSequenceA?.sourceEvents,
                    b: self._sceneView.sourceSequenceB?.sourceEvents
                )
            )
        }
            .disposed(by: disposeBag)
    }
    
    private func updateEvents(_ sourceEvents: (a: [EventView]?, b: [EventView]?)) {
        let scheduler = TestScheduler(initialClock: 0)
        
        var first: TestableObservable<ColoredType>? = nil
        
        if sourceEvents.a != nil {
            let events = sourceEvents.a!.map({ $0.recorded })
            first = scheduler.createColdObservable(events)
        }
        
        var second: TestableObservable<ColoredType>? = nil
        if _operator.multiTimelines {
            if let s = sourceEvents.b {
                let secondEvents = s.map({ $0.recorded })
                second = scheduler.createColdObservable(secondEvents)
            }
        }
        
        let o = _operator._map(scheduler, aO:first, bO:second)
        
        var res: TestableObserver<ColoredType>?
        res = scheduler.start(created: 0, subscribed: 0, disposed: 1001) {
            return o
        }
        
        addEventsToTimeline(res!.events)
    }
    
    func addEventsToTimeline(_ events: [RecordedType]) {
        sourceEvents.forEach { $0.removeFromSuperview() }
        
        let sortedEvents = events.sorted {
            return $0.time < $1.time
        }
        
        if !sortedEvents.isEmpty {
            let ang = angles(sortedEvents)

            var newSourceEvents = [EventView]()
            sortedEvents.forEach { event in
                switch event.value {
                case .next:
                    let angleIndex = sortedEvents.firstIndex(where: { $0 == event })
                    let angle = ang[angleIndex!]
                    if let index = sourceEvents.firstIndex(where: { $0.isNext }) {
                        let eventView = reuseEventView(index: index, recorded: event)
                        eventView.refreshColorAndValue()
                        newSourceEvents.append(eventView)
                        Animation.rotate(eventView, toAngle: angle)
                    } else {
                        let eventView = newEventView(recorded: RecordedType(time: event.time, value: event.value))
                        newSourceEvents.append(eventView)
                        Animation.rotate(eventView, toAngle: angle)
                    }
                case .completed:
                    if let index = sourceEvents.firstIndex(where: { $0.isCompleted }) {
                        newSourceEvents.append(reuseEventView(index: index, recorded: RecordedType(time: event.time, value: .completed)))
                    } else {
                        newSourceEvents.append(newEventView(recorded: RecordedType(time: event.time, value: .completed)))
                    }
                case .error:
                    if let index = sourceEvents.firstIndex(where: { $0.isError }) {
                        newSourceEvents.append(reuseEventView(index: index, recorded: RecordedType(time: event.time, value: .error(RxError.unknown))))
                    } else {
                        newSourceEvents.append(newEventView(recorded: RecordedType(time: event.time, value: .error(RxError.unknown))))
                    }
                }
            }
            sourceEvents = newSourceEvents
        }
    }
    
    private func reuseEventView(index: Int, recorded: RecordedType) -> EventView {
        let reuseEventView = sourceEvents[index]
        _ = sourceEvents.remove(at: index)
        reuseEventView.recorded = RecordedType(time: recorded.time, value: recorded.value)
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
        UIView.animate(withDuration: 0.3) { 
            self.alpha = self.editing ? 0.5 : 1.0
        }
        if !editing {
            sourceEvents.forEach(Animation.scale)
        }
    }
}
