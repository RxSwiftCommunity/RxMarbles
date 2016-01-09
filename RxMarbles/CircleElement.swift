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

class CircleElement<Element: Equatable>: SKShapeNode {
    private var _recorded = Recorded(time: 0, event: Event<Element>.Completed)
    var timelineAxisY: CGFloat!
    
    var recorded: Recorded<Event<Element>> {
        set (newValue) { _recorded = newValue }
        get { return _recorded }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override init() {
        super.init()
    }
    
    
    convenience init(recorded: Recorded<Event<Element>>, color: SKColor, name: String, timelineAxisY: CGFloat) {
        self.init()
        self.init(circleOfRadius: 19.0)
        
        self.timelineAxisY = timelineAxisY
        
        self._recorded = recorded
        self.fillColor = color
        self.strokeColor = SKColor.blackColor()
        self.lineWidth = 0.5
        self.name = name
        self.position = CGPointMake(CGFloat(_recorded.time), timelineAxisY)
        self.zPosition = 2
        
        let circleTitle = SKLabelNode()
//        circleTitle.fontName = "Copperplate"
        circleTitle.fontName = ".AppleSystemUIFont"
        circleTitle.fontColor = .whiteColor()
        circleTitle.fontSize = 17.0
        let elem = recorded.value.element! as! ColoredType
        circleTitle.text = "\(elem.value)"
        circleTitle.name = "title"
        circleTitle.zPosition = 0
        circleTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        circleTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        self.addChild(circleTitle)
    }
}