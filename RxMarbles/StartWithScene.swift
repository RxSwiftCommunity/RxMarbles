//
//  StartWithScene.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 09.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import SpriteKit
import RxSwift

class StartWithScene: TemplateScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        drawTimeLine(100.0, name: "timeline")
        for i in 1..<4 {
            let color = RXMUIKit.randomColor()
            let t = ColoredType(value: i, color: color)
            sourceEvents.append(drawCircleElementWithOptions("", color: color, timelineName: "timeline", time: 50 * i, t: t))
        }
        
        let completedLine = drawEndOnTimeLineWithName("completed", axisX: frame.size.width - 30.0, timelineName: "timeline")
        sourceEvents.append(completedLine)
        
        drawTimeLine(200.0, name: "resultTimeline")
        
        updateResult()
    }
    
    
    //    MARK: startWith
    override func map(o: Observable<ColoredType>, scheduler: TestScheduler) -> Observable<ColoredType> {
        return o.startWith(ColoredType(value: 2, color: RXMUIKit.randomColor()))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
