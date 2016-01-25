//
//  TimelineView.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 21.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit

class TimelineView: UIView {
    var sourceEvents = [EventView]()
    let timeArrow = UIImageView(image: Image.timeLine)
    weak var sceneView: SceneView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(timeArrow)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        timeArrow.frame = CGRectMake(0, 0, self.frame.width, Image.timeLine.size.height)
        timeArrow.center.y = self.bounds.height / 2.0
        bringStopEventViewsToFront(sourceEvents)
    }
    
    func maxEventTime() -> Int? {
        let times = sourceEvents.map({ $0.recorded.time })
        return times.maxElement()
    }
    
    func xPositionByTime(time: Int) -> CGFloat {
        let maxTime: CGFloat = 1000.0
        let width = bounds.size.width
        return (width / maxTime) * CGFloat(time)
    }
    
    func timeByXPosition(x: CGFloat) -> Int {
        let maxTime: CGFloat = 1000.0
        let width = bounds.size.width
        return Int((maxTime / width) * x)
    }
    
    func bringStopEventViewsToFront(sourceEvents: [EventView]) {
        sourceEvents.forEach({ if $0.recorded.value.isStopEvent { self.bringSubviewToFront($0) } })
    }
}