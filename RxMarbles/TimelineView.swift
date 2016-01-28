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
    var editing: Bool = false {
        didSet {
            setEditing()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(timeArrow)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        timeArrow.frame = CGRectMake(0, 0, bounds.width, Image.timeLine.size.height)
        timeArrow.center.y = bounds.height / 2.0
    }
    
    func maxEventTime() -> Int? {
        let max = sourceEvents
            .map({ $0.recorded.time })
            .maxElement()
        return max != nil ? max : 0
    }
    
    func xPositionByTime(time: Int) -> CGFloat {
        let maxTime: CGFloat = 1000.0
        let width = timeArrow.bounds.size.width - 30
        return (width / maxTime) * CGFloat(time)
    }
    
    func timeByXPosition(x: CGFloat) -> Int {
        let maxTime: CGFloat = 1000.0
        let width = timeArrow.bounds.size.width - 30
        var time: Int = 0
        if x < 0 {
            time = 0
        } else if x >= width {
            time = 1000
        } else {
            time = Int((maxTime / width) * x)
        }
        return time
    }
    
    func setEditing() {
        //overloading
    }
}