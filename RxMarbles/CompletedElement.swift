//
//  CompletedElement.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 07.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import SpriteKit
import RxSwift

class CompletedElement: SKShapeNode {
    var timelineAxisY: CGFloat!
    var time: CGFloat!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override init() {
        super.init()
    }
    
    
    convenience init(name: String, time: CGFloat, timelineAxisY: CGFloat) {
        
        let endLine = UIBezierPath()
        endLine.moveToPoint(CGPointMake(time, timelineAxisY - 22.0))
        endLine.addLineToPoint(CGPointMake(time, timelineAxisY + 22.0))
        
        self.init()
        self.init(path: endLine.CGPath)
        
        self.time = time
        self.timelineAxisY = timelineAxisY
        
        self.strokeColor = SKColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1.0)
        self.lineWidth = 3.0
        self.name = name
        self.position = CGPointMake(time, timelineAxisY)
        self.zPosition = 1
    }
}
