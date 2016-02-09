//
//  TimelineView.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 21.01.16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import UIKit
import RxSwift
import Device

class TimelineView: UIView {
    
    var sourceEvents = [EventView]()
    let timeArrow = UIImageView(image: Image.timeLine)
    var debounce: RxTimeInterval!
    var disposeBag = DisposeBag()
    weak var sceneView: SceneView!
    var subject = PublishSubject<Void>()
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
        
        let powerDevices = [
            Version.iPhone6,
            Version.iPhone6S,
            Version.iPhone6Plus,
            Version.iPhone6SPlus,
            Version.iPodTouch6Gen,
            Version.iPadAir2,
            Version.iPadMini3,
            Version.iPadMini4,
            Version.iPadPro
        ]
        debounce = powerDevices.contains(Device.version()) ? 0.008 : 0.03
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        timeArrow.frame = CGRectMake(0, 0, bounds.width, Image.timeLine.size.height)
        timeArrow.center.y = bounds.height / 2.0
    }
    
    func maxEventTime() -> Int {
        return sourceEvents
            .map({ $0.recorded.time })
            .maxElement() ?? 0
    }
    
    func xPositionByTime(time: Int) -> CGFloat {
        let maxTime: CGFloat = 1000.0
        let width = timeArrow.bounds.size.width - 25
        return (width / maxTime) * CGFloat(time)
    }
    
    func timeByXPosition(x: CGFloat) -> Int {
        let maxTime: CGFloat = 1000.0
        let width = timeArrow.bounds.size.width - 25
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
    
    func angles(events: [RecordedType]) -> [CGFloat] {
        var angles: [CGFloat] = []
        angles.append(0.0)
        for index in 1..<events.count {
            let prev = events[index - 1]
            let prevAngle = angles[index - 1]
            let current = events[index]
            let delta: Int = 19
            if ((current.time > prev.time - delta) && (current.time < prev.time + delta)) && current.value.isStopEvent == false {
                angles.append(prevAngle + CGFloat(M_PI / 5.15))
            } else {
                angles.append(0.0)
            }
        }
        return angles
    }
    
    func setEditing() {
        //overloading
    }
}