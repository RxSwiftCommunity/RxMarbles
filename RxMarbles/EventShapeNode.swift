//
//  CircleElement.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 07.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import SpriteKit
import RxSwift

struct ColoredType: Equatable {
    var value: Int
    var color: SKColor
}

typealias Element = ColoredType

func ==(lhs: Element, rhs: Element) -> Bool {
    return lhs.value == rhs.value && lhs.color == rhs.color
}

class EventShapeNode: SKShapeNode {
    typealias RecordedType = Recorded<Event<ColoredType>>
    
    var recorded = RecordedType(time: 0, event: .Completed)
    var timelineAxisY: CGFloat = 0
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override init() {
        super.init()
    }
    
    convenience init(recorded: RecordedType, name: String, timelineAxisY: CGFloat) {
        self.init()
        
        switch recorded.value {
        case let .Next(v):
            self.init(circleOfRadius: 19.0)
            fillColor = v.color
            let title = SKLabelNode()
            title.fontName = ".AppleSystemUIFont"
            title.fontColor = .whiteColor()
            title.fontSize = 17.0
            title.text = "\(v.value)"
            title.name = "title"
            title.zPosition = 0
            title.horizontalAlignmentMode = .Center
            title.verticalAlignmentMode = .Center
            addChild(title)
            zPosition = 2
            strokeColor = SKColor.blackColor()
            lineWidth = 0.5
        case .Completed:
            let path = UIBezierPath()
            path.moveToPoint(CGPointMake(CGFloat(recorded.time), timelineAxisY - 22.0))
            path.addLineToPoint(CGPointMake(CGFloat(recorded.time), timelineAxisY + 22.0))
            self.init(path: path.CGPath)
            zPosition = 1
            strokeColor = SKColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1.0)
            lineWidth = 3.0
        default: break
        }
        
        
        self.timelineAxisY = timelineAxisY
        self.recorded = recorded
        self.name = name
        position = CGPointMake(CGFloat(recorded.time), timelineAxisY)
    }
}