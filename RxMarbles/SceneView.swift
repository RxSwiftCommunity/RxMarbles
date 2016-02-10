
//
//  SceneView.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 21.01.16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Device

class SceneView: UIView, UITextViewDelegate {
    var trashView = UIImageView(image: Image.rubbish.imageWithRenderingMode(.AlwaysTemplate))
    var rxOperator: Operator
    let rxOperatorText = UITextView()
    
    private let _rxOperatorLabel = UILabel()
    private var _aLabel: UILabel?
    private var _bLabel: UILabel?
    
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
    
    var editing: Bool = false {
        didSet {
            resultTimeline.editing = editing
            sourceTimeline?.editing = editing
            secondSourceTimeline?.editing = editing
            dimRxOperatorText(editing)
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
        _rxOperatorLabel.textAlignment = .Center
        _rxOperatorLabel.minimumScaleFactor = 0.5
        _rxOperatorLabel.adjustsFontSizeToFitWidth = true
        _rxOperatorLabel.attributedText = rxOperator.higlightedCode()
        
        addSubview(rxOperatorText)
        rxOperatorText.delegate = self
        rxOperatorText.editable = false
        rxOperatorText.scrollEnabled = false
        rxOperatorText.userInteractionEnabled = true
        rxOperatorText.dataDetectorTypes = UIDataDetectorTypes.Link
        rxOperatorText.attributedText = rxOperator.linkText
        
        resultTimeline = ResultTimelineView(frame: CGRectMake(0, 0, bounds.width, 60), rxOperator: rxOperator, sceneView: self)
        if !rxOperator.withoutTimelines {
            sourceTimeline = SourceTimelineView(frame: CGRectMake(0, 0, bounds.width, 60), scene: self)
            _aLabel = UILabel()
            _aLabel!.text = "a: "
            _aLabel!.font = UIFont.monospacedDigitSystemFontOfSize(14, weight: UIFontWeightRegular)
            addSubview(_aLabel!)
            if rxOperator.multiTimelines {
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
        let labelHeight: CGFloat = 40
        
        _rxOperatorLabel.frame = CGRectMake(0, 20, bounds.width, labelHeight)
        if !rxOperator.withoutTimelines {
            sourceTimeline.frame = CGRectMake(20, 20, bounds.width - 20, height)
            _rxOperatorLabel.frame.origin.y = sourceTimeline.frame.origin.y + height
            _aLabel?.frame = CGRectMake(0, sourceTimeline.frame.origin.y, 20, height)
            
            if rxOperator.multiTimelines {
                secondSourceTimeline.frame = CGRectMake(20, sourceTimeline.frame.origin.y + sourceTimeline.frame.height, bounds.width - 20.0, height)
                _bLabel?.frame = CGRectMake(0, secondSourceTimeline.frame.origin.y, 20, height)
                _rxOperatorLabel.frame.origin.y = secondSourceTimeline.frame.origin.y + height
            }
        }
        resultTimeline.frame = CGRectMake(20, _rxOperatorLabel.frame.origin.y + labelHeight + 10, bounds.width - 20, height)
        
        let size = rxOperatorText.text.boundingRectWithSize(CGSizeMake(bounds.width, 1000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: rxOperatorText.font!], context: nil).size
        rxOperatorText.frame = CGRectMake(0, resultTimeline.frame.origin.y + resultTimeline.frame.height + 10, bounds.width, size.height + 40)
        
        if UIApplication.sharedApplication().statusBarOrientation.isLandscape && Device.isSmallerThanScreenSize(.Screen4_7Inch) && Device.size() != .UnknownSize {
            trashView.center = CGPointMake(rxOperatorText.center.x, UIScreen.mainScreen().bounds.height - 60)
        } else {
            trashView.center = rxOperatorText.center
        }
        resultTimeline.subject.onNext()
    }
    
    func showTrashView() {
        addSubview(trashView)
        trashView.hidden = false
        trashView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        trashView.alpha = 0.05
        trashView.tintColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        UIView.animateWithDuration(0.3) { _ in
            self.rxOperatorText.alpha = 0.04
            self.trashView.alpha = 0.2
            self.trashView.transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.trashView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        }
    }
    
    func hideTrashView() {
        Animation.hideWithCompletion(trashView) { _ in
            UIView.animateWithDuration(0.3) { _ in
                self.rxOperatorText.alpha = 1.0
            }
            self.trashView.removeFromSuperview()
        }
    }
    
    func dimRxOperatorText(editing: Bool) {
        rxOperatorText.selectable = !editing
        UIView.animateWithDuration(0.3) {
            self.rxOperatorText.alpha = editing ? 0.2 : 1.0
        }
    }
    
//    MARK: UITextViewDelegate methods
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        NSNotificationCenter.defaultCenter().postNotificationName(Names.openOperatorDescription, object: nil)
        return false
    }
}