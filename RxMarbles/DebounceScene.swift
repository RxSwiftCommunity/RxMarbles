//
//  DebounceScene.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 09.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import SpriteKit
import RxSwift

class DebounceScene: TemplateScene {

    var completedLine: SKShapeNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        drawTimeLine(100.0, name: "timeline")
        for i in 1..<4 {
            let color = RXMUIKit.randomColor()
            let t = ColoredType(value: i, color: color)
            sourceEvents.append(drawCircleElementWithOptions("", color: color, timelineName: "timeline", time: 50 * i, t: t))
        }
        
        completedLine = drawEndOnTimeLineWithName("completed", axisX: frame.size.width - 30.0, timelineName: "timeline")
        
        drawTimeLine(200.0, name: "resultTimeline")
        
        updateResult()
    }
    
    override func updateResult() {
        debounce()
    }
    
    //    MARK: debounce
    
    func debounce() {
        let scheduler = TestScheduler(initialClock: 0)
        
        var events = sourceEvents.map({ $0.recorded })
        events.append(Recorded(time: Int(completedLine.position.x), event: Event.Completed))
        
        let t = scheduler.createColdObservable(
            events
        )
        
        let res = scheduler.start(0, subscribed: 0, disposed: Int(frame.width)) {
            return t.debounce(50, scheduler: scheduler)
        }
        
        createResultTimelineElements(res.events)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
