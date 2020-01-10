//
//  EventView.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 21.01.16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import UIKit
import RxSwift

class EventView: UIView {
    weak var animator: UIDynamicAnimator? = nil
    weak var sequenceView: SourceSequenceView?
    
    var recorded = RecordedType(time: 0, value: .completed)
    
    var snap: UISnapBehavior? = nil
    var gravity: UIGravityBehavior? = nil
    var removeBehavior: UIDynamicItemBehavior? = nil
    
    private let _tapGestureRecognizer = UITapGestureRecognizer()
    private let _imageView = UIImageView()
    
    var label = UILabel()
    
    init(recorded: RecordedType) {
        super.init(frame: CGRect(x: 0, y: 0, width: 42, height: 50))
       
        _imageView.contentMode = .center
        if #available(iOS 13.0, *) {
            label.textColor = .systemGray
        }
        label.font = Font.ultraLightText(11)
        addSubview(_imageView)
        addSubview(label)
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        switch recorded.value {
        case let .next(v):
            if let value = recorded.value.element?.value {
                label.text = value
                label.sizeToFit()
            }
            
            _imageView.image = v.shape.image(v.color)
            _imageView.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        case .completed:
            _imageView.image = RxMarbles.Image.complete
            if #available(iOS 13.0, *) {
                _imageView.tintColor = .label
            } else {
               _imageView.tintColor = .black
            }
            layer.zPosition = -1
        case .error:
            _imageView.image = RxMarbles.Image.error
            if #available(iOS 13.0, *) {
                _imageView.tintColor = .label
            } else {
               _imageView.tintColor = .black
            }
            layer.zPosition = -1
        }
      
        
        gravity = UIGravityBehavior(items: [self])
        removeBehavior = UIDynamicItemBehavior(items: [self])
        removeBehavior?.action = {
            let sequenceView = self.sequenceView
            if let scene = sequenceView?.sceneView {
                if let index = sequenceView?.sourceEvents.firstIndex(of: self) {
                    if scene.bounds.intersects(self.frame) == false {
                        self.removeFromSuperview()
                        sequenceView?.sourceEvents.remove(at: index)
                        scene.resultSequence.subject.onNext(())
                    }
                }
            }
        }
        self.recorded = recorded
        _tapGestureRecognizer.addTarget(self, action: #selector(EventView.setEventView))
        _tapGestureRecognizer.isEnabled = false
        addGestureRecognizer(_tapGestureRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _imageView.center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        label.center = CGPoint(x: bounds.width / 2.0, y: bounds.height * 0.15)
    }
    
    func use(animator: UIDynamicAnimator?, sequence: SourceSequenceView?) {
        if let snap = snap {
            animator?.removeBehavior(snap)
        }
        self.animator = animator
        self.sequenceView = sequence
        if let sequence = sequence {
            let x = sequence.xPositionByTime(recorded.time)
            center = CGPoint(x: x, y: sequence.bounds.height / 2.0)
            snap = UISnapBehavior(item: self, snapTo: CGPoint(x: x, y: center.y))
        }
        
        
        isUserInteractionEnabled = animator != nil
    }
    
    var isCompleted: Bool {
        if case .completed = recorded.value {
            return true
        } else {
            return false
        }
    }
    
    var isNext: Bool {
        if case .next = recorded.value {
            return true
        } else {
            return false
        }
    }
    
    var isError: Bool {
        if case .error = recorded.value {
            return true
        } else {
            return false
        }
    }
    
    func addTapRecognizer() {
        _tapGestureRecognizer.isEnabled = true
    }
    
    func removeTapRecognizer() {
        _tapGestureRecognizer.isEnabled = false
    }
    
    @objc func setEventView() {
        Notifications.setEventView.post(object: self)
    }
    
    func setGhostColorOnDeleteZone(onDeleteZone: Bool) {
        let color: UIColor = onDeleteZone ? .red : .gray
        let alpha: CGFloat = onDeleteZone ? 1.0 : 0.2
        switch recorded.value {
        case .next:
            _imageView.image = recorded.value.element?.shape.image.withRenderingMode(.alwaysTemplate)
        case .completed:
            _imageView.image = RxMarbles.Image.complete.withRenderingMode(.alwaysTemplate)
        case .error:
            _imageView.image = RxMarbles.Image.error.withRenderingMode(.alwaysTemplate)
        }
        _imageView.tintColor = color
        self.alpha = alpha
    }
    
    func setColorOnPreview(color: UIColor) {
        _imageView.image = recorded.value.element?.shape.image(color)
    }
    
    func refreshColorAndValue() {
        if let color = recorded.value.element?.color {
            _imageView.image = recorded.value.element?.shape.image(color)
        }
        if let value = recorded.value.element?.value {
            label.text = value
            label.sizeToFit()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
