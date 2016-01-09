//
//  MapScene.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 09.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import SpriteKit
import RxSwift

class MapScene: TemplateScene {
    
    var completedLine: SKShapeNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        drawTimeLine(100.0, name: "timeline")
        for i in 1..<4 {
            let color = RXMUIKit.randomColor()
            let t = Element(value: i, color: color)
            sourceEvents.append(drawCircleElementWithOptions("", color: color, timelineName: "timeline", time: 50 * i, t: t))
        }
        
        completedLine = drawEndOnTimeLineWithName("completed", axisX: frame.size.width - 30.0, timelineName: "timeline")
        
        drawTimeLine(200.0, name: "resultTimeline")
        
        synchronizeTimeLines()
    }
    
    override func synchronizeTimeLines() {
        map()
    }
    
    //    MARK: map
    
    func map() {
        let scheduler = TestScheduler(initialClock: 0)
        
        var events = sourceEvents.map({ $0.recorded })
        events.append(Recorded(time: Int(completedLine.position.x), event: Event.Completed))
        
        let t = scheduler.createColdObservable(
            events
        )
        
        let res = scheduler.start(0, subscribed: 0, disposed: Int(frame.width)) {
            return t.map({ h in Element(value: h.value * 10, color: h.color) })
        }
        
        createResultTimelineElements(res.events)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
