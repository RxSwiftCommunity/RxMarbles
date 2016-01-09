//
//  TemplateScene.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 06.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import SpriteKit
import RxSwift

class TemplateScene: SKScene {
    
    typealias RecordedType = EventShapeNode.RecordedType
    
    var sourceEvents = [EventShapeNode]()
    var selectedNode: EventShapeNode? = nil
    var needUpdate = false
    
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = SKColor.whiteColor()
    }
    
    func drawTimeLine(axisY: CGFloat, name: String) {
        let arrow = UIBezierPath()
        let maxY = frame.maxY
        let maxX = frame.maxX
        arrow.moveToPoint(CGPointMake(frame.minX, 0.0))
        arrow.addLineToPoint(CGPointMake(maxX - 10.0, 0.0))
        arrow.addLineToPoint(CGPointMake(maxX - 10.0, -3.5))
        arrow.addLineToPoint(CGPointMake(maxX, 0.0))
        arrow.addLineToPoint(CGPointMake(maxX - 10.0, 3.5))
        arrow.addLineToPoint(CGPointMake(maxX - 10.0, 0.0))
        
        let timeLine = SKShapeNode(path: arrow.CGPath)
        timeLine.strokeColor = SKColor.blackColor()
        timeLine.fillColor = SKColor.blackColor()
        timeLine.antialiased = false
        timeLine.lineWidth = 0.5
        timeLine.position = CGPointMake(0.0, maxY - axisY)
        timeLine.name = name
        timeLine.zPosition = 0
        addChild(timeLine)
    }
    
    func drawEndOnTimeLineWithName(name: String, axisX: CGFloat, timelineName: String) -> SKShapeNode {
        let timeline: SKShapeNode = childNodeWithName(timelineName) as! SKShapeNode
        
        let endLine = UIBezierPath()
        endLine.moveToPoint(CGPointMake(0.0, -22.0))
        endLine.addLineToPoint(CGPointMake(0.0, 22.0))
        
        let endOfTimeline = SKShapeNode(path: endLine.CGPath)
        endOfTimeline.name = name
        
        endOfTimeline.strokeColor = SKColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1.0)
        endOfTimeline.lineWidth = 3.0
        
        endOfTimeline.zPosition = 1
        endOfTimeline.position = CGPointMake(axisX, 0.0)
        
//        let endOfTimeline = CompletedElement(name: name, time: axisX, timelineAxisY: timeline.position.y)
        
        timeline.addChild(endOfTimeline)
        
        return endOfTimeline
    }
   
    // TODO: draw is bad verbe for creating node
    func drawCircleElementWithOptions(name: String, color: SKColor, timelineName: String, time: Int, t: ColoredType) -> EventShapeNode {
        let timeline: SKShapeNode = childNodeWithName(timelineName) as! SKShapeNode
        let event = Event.Next(ColoredType(value: time, color: color))
        let circleElement = EventShapeNode(recorded: Recorded(time: time, event: event), name: name, timelineAxisY: timeline.position.y)
        
        self.addChild(circleElement)
        
        if circleElement.name?.containsString("result") == false {
            let addActionStageFirst = SKAction.scaleBy(2.0, duration: 0.2)
            let addActionStageSecond = SKAction.scaleBy(0.5, duration: 0.2)
            let sequence = SKAction.sequence([addActionStageFirst, addActionStageSecond])
            circleElement.runAction(sequence)
        }
        
        return circleElement
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInNode(self)
        var node = nodeAtPoint(location)
        if node.isKindOfClass(SKLabelNode) {
            node = node.parent!
        }
        if node.zPosition == 2 && (node.name?.containsString("result") == false) {
            selectedNode = node as? EventShapeNode
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if selectedNode != nil {
            let touch = touches.first
            let location = touch?.locationInNode(self)
            let moveToLocation = SKAction.moveTo(location!, duration: 0.01)
            selectedNode?.runAction(moveToLocation)
            
            if childNodeWithName("normal") != nil {
                removeChildrenInArray([childNodeWithName("normal")!])
            }
            
            let normal = SKShapeNode()
            normal.name = "normal"
            let path = UIBezierPath()
            path.moveToPoint((selectedNode?.position)!)
            path.addLineToPoint(CGPointMake((selectedNode?.position.x)!, (selectedNode?.timelineAxisY)! - 10.0))
            path.addLineToPoint(CGPointMake((selectedNode?.position.x)! + 3.5, (selectedNode?.timelineAxisY)! - 10.0))
            path.addLineToPoint(CGPointMake((selectedNode?.position.x)!, (selectedNode?.timelineAxisY)!))
            path.addLineToPoint(CGPointMake((selectedNode?.position.x)! - 3.5, (selectedNode?.timelineAxisY)! - 10.0))
            path.addLineToPoint(CGPointMake((selectedNode?.position.x)!, (selectedNode?.timelineAxisY)! - 10.0))
            normal.path = path.CGPath
            normal.strokeColor = .grayColor()
            if location?.y < self.frame.size.height / 7.0 {
                normal.strokeColor = .redColor()
            }
            normal.antialiased = false
            normal.lineWidth = 0.5
            addChild(normal)
            
            selectedNode!.recorded = RecordedType(time: Int(selectedNode!.position.x), event: selectedNode!.recorded.value)
            
            updateResult()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if selectedNode != nil {
            let touch = touches.first
            let location = touch?.locationInNode(self)
            if location?.y < self.frame.size.height / 7.0 {
                if childNodeWithName("normal") != nil {
                    removeChildrenInArray([childNodeWithName("normal")!])
                }
                let index = sourceEvents.indexOf(selectedNode!)
                sourceEvents.removeAtIndex(index!)
                let removeStageFirst = SKAction.scaleBy(2.0, duration: 0.2)
                let removeStageSecond = SKAction.scaleBy(0.1, duration: 0.3)
                let rotateNode = SKAction.rotateToAngle(CGFloat(4.0 * M_PI), duration: 0.5)
                let removeStages = SKAction.sequence([removeStageFirst, removeStageSecond])
                let removeStagesWithRotation = SKAction.group([removeStages, rotateNode])
                let remove = SKAction.removeFromParent()
                let fullRemoveAction = SKAction.sequence([removeStagesWithRotation, remove])
                selectedNode?.runAction(fullRemoveAction)
                selectedNode = nil
                
                updateResult()
                
            } else {
                let moveToTimeline = SKAction.moveToY(selectedNode!.timelineAxisY, duration: 0.1)
                self.needUpdate = true
                selectedNode?.runAction(moveToTimeline, completion: { () -> Void in
                    if self.childNodeWithName("normal") != nil {
                        self.removeChildrenInArray([self.childNodeWithName("normal")!])
                    }
                    self.needUpdate = false
                    self.selectedNode!.recorded = Recorded(time: Int((self.selectedNode?.position.x)!), event: self.selectedNode!.recorded.value)
                    self.selectedNode = nil
                    self.updateResult()
                })
            }
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        if self.needUpdate == true {
            if selectedNode != nil {
                if childNodeWithName("normal") != nil {
                    removeChildrenInArray([childNodeWithName("normal")!])
                }
                
                let normal = SKShapeNode()
                normal.name = "normal"
                let path = UIBezierPath()
                path.moveToPoint((selectedNode?.position)!)
                path.addLineToPoint(CGPointMake((selectedNode?.position.x)!, (selectedNode?.timelineAxisY)! - 10.0))
                path.addLineToPoint(CGPointMake((selectedNode?.position.x)! + 3.5, (selectedNode?.timelineAxisY)! - 10.0))
                path.addLineToPoint(CGPointMake((selectedNode?.position.x)!, (selectedNode?.timelineAxisY)!))
                path.addLineToPoint(CGPointMake((selectedNode?.position.x)! - 3.5, (selectedNode?.timelineAxisY)! - 10.0))
                path.addLineToPoint(CGPointMake((selectedNode?.position.x)!, (selectedNode?.timelineAxisY)! - 10.0))
                normal.path = path.CGPath
                normal.strokeColor = .grayColor()
                normal.antialiased = false
                normal.lineWidth = 0.5
                addChild(normal)
                
                self.selectedNode!.recorded = RecordedType(time: Int((self.selectedNode?.position.x)!), event: self.selectedNode!.recorded.value)
                updateResult()
            }
        }
    }
    
    func updateResult() {
        let scheduler = TestScheduler(initialClock: 0)
        let events = sourceEvents.map({ $0.recorded })
        let t = scheduler.createColdObservable(
            events
        )
        let o = map(t.asObservable(), scheduler: scheduler)
        let res = scheduler.start(0, subscribed: 0, disposed: Int(frame.width)) {
            return o
        }
        createResultTimelineElements(res.events)
    }
    
    
    func map(o: Observable<ColoredType>, scheduler: TestScheduler) -> Observable<ColoredType> {
        return Observable.never()
    }
    
    func createResultTimelineElements(events: [RecordedType]?) {
        var elements = [EventShapeNode]()
        self.children.forEach { (node) -> () in
            if node.isKindOfClass(EventShapeNode) {
                if (node.name?.containsString("result") == true) {
                    elements.append(node as! EventShapeNode)
                }
            }
        }
        
        self.removeChildrenInArray(elements)
        
        if events != nil {
            events!.forEach({ (event) -> () in
                if event.value.isStopEvent == false {
                    drawCircleElementWithOptions("result", color: (event.value.element?.color)!, timelineName: "resultTimeline", time: event.time, t: event.value.element!)
                } else {
                    let resultTimeline: SKShapeNode = childNodeWithName("resultTimeline") as! SKShapeNode
                    
                    if resultTimeline.childNodeWithName("end") != nil {
                        resultTimeline.removeChildrenInArray([(resultTimeline.childNodeWithName("end"))!])
                    }
                    drawEndOnTimeLineWithName("end", axisX: CGFloat(event.time), timelineName: "resultTimeline")
                }
            })
        }
    }
    
    func addElement() {
        let color = RXMUIKit.randomColor()
        let t = ColoredType(value: 1, color: color)
        sourceEvents.append(drawCircleElementWithOptions("", color: color, timelineName: "timeline", time: 100, t: t))
        updateResult()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}