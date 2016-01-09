//
//  ReduceScene.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 09.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import SpriteKit
import RxSwift

class ReduceScene: TemplateScene {
    
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: reduce
    override func map(o: Observable<ColoredType>, scheduler: TestScheduler) -> Observable<ColoredType> {
        return o.reduce(ColoredType(value: 0, color: .redColor()), accumulator: { acc, e in
            var res = acc
            res.value += e.value
            res.color = e.color
            return res
        })
    }
    
}
