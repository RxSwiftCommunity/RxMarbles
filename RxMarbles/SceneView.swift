
//
//  SceneView.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 21.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SceneView: UIView {
    var sourceTimeline: SourceTimelineView! {
        didSet {
            addSubview(sourceTimeline)
            
            let initial = rxOperator.initial
            for t in initial.line1 {
                sourceTimeline.addEventToTimeline(t, animator: sourceTimeline.animator)
            }
        }
    }
    var secondSourceTimeline: SourceTimelineView! {
        didSet {
            addSubview(secondSourceTimeline)

            let initial = rxOperator.initial
            for t in initial.line2 {
                secondSourceTimeline.addEventToTimeline(t, animator: secondSourceTimeline.animator)
            }
        }
    }
    var resultTimeline: ResultTimelineView! {
        didSet {
            addSubview(resultTimeline)
        }
    }
    var trashView = UIImageView(image: Image.rubbish.imageWithRenderingMode(.AlwaysTemplate))
    var rxOperator: Operator
    private let _rxOperatorLabel = UILabel()
    private var _aLabel: UILabel?
    private var _bLabel: UILabel?
    var editing: Bool = false {
        didSet {
            resultTimeline.editing = editing
            if !rxOperator.withoutTimelines {
                sourceTimeline.editing = editing
                if rxOperator.multiTimelines {
                    secondSourceTimeline.editing = editing
                }
            }
            setNeedsLayout()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(rxOperator: Operator, frame: CGRect) {
        self.rxOperator = rxOperator
        super.init(frame: frame)
        trashView.frame = CGRectMake(0, 0, 40, 40)
        setTimelines()
    }
    
    private func setTimelines() {
        addSubview(_rxOperatorLabel)
        _rxOperatorLabel.text = rxOperator.code
        _rxOperatorLabel.font = UIFont.monospacedDigitSystemFontOfSize(14, weight: UIFontWeightRegular)
        _rxOperatorLabel.textAlignment = .Center
        _rxOperatorLabel.textColor = .blackColor()
        
        resultTimeline = ResultTimelineView(frame: CGRectMake(0, 0, bounds.width, 60), rxOperator: rxOperator, sceneView: self)
        if !rxOperator.withoutTimelines {
            sourceTimeline = SourceTimelineView(frame: CGRectMake(0, 0, bounds.width, 60), scene: self)
            if rxOperator.multiTimelines {
                _aLabel = UILabel()
                _aLabel!.text = "a: "
                _aLabel!.font = UIFont.monospacedDigitSystemFontOfSize(14, weight: UIFontWeightRegular)
                addSubview(_aLabel!)
                _bLabel = UILabel()
                _bLabel!.text = "b: "
                _bLabel!.font = UIFont.monospacedDigitSystemFontOfSize(14, weight: UIFontWeightRegular)
                addSubview(_bLabel!)
                secondSourceTimeline = SourceTimelineView(frame: CGRectMake(0, 0, bounds.width, 60), scene: self)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height: CGFloat = 60
        let labelHeight: CGFloat = 20
        
        _rxOperatorLabel.frame = CGRectMake(0, 20, bounds.width, labelHeight)
        if !rxOperator.withoutTimelines {
            sourceTimeline.frame = CGRectMake(0, 20, bounds.width, height)
            _rxOperatorLabel.frame.origin.y = sourceTimeline.frame.origin.y + height
            sourceTimeline.subject.onNext()
            if rxOperator.multiTimelines {
                sourceTimeline.frame.origin.x = 20
                sourceTimeline.frame.size.width = bounds.width - 20.0
                secondSourceTimeline.frame = CGRectMake(20, sourceTimeline.frame.origin.y + sourceTimeline.frame.height, bounds.width - 20.0, height)
                _aLabel?.frame = CGRectMake(0, sourceTimeline.frame.origin.y, 20, height)
                _bLabel?.frame = CGRectMake(0, secondSourceTimeline.frame.origin.y, 20, height)
                secondSourceTimeline.subject.onNext()
                _rxOperatorLabel.frame.origin.y = secondSourceTimeline.frame.origin.y + height
            }
        }
        resultTimeline.frame = CGRectMake(0, _rxOperatorLabel.frame.origin.y + labelHeight, bounds.width, height)
        
        let trashVerticalPosition = resultTimeline.frame.origin.y + resultTimeline.frame.height + 25
        trashView.center = CGPointMake(bounds.width / 2.0, trashVerticalPosition)
        resultTimeline.subject.onNext()
    }
    
    func showTrashView() {
        addSubview(trashView)
        trashView.hidden = false
        trashView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        trashView.alpha = 0.05
        trashView.tintColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        UIView.animateWithDuration(0.3) { _ in
            self.trashView.alpha = 0.2
            self.trashView.transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.trashView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        }
    }
    
    func hideTrashView() {
        trashView.hideWithCompletion({ _ in self.trashView.removeFromSuperview() })
    }
}