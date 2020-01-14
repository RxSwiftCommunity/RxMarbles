
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
    var trashView = RxMarbles.Image.rubbish.withRenderingMode(.alwaysTemplate).imageView()
    var rxOperator: Operator
    let rxOperatorText = UITextView()
    
    private let _rxOperatorLabel = UILabel()
    private var _aLabel: UILabel?
    private var _bLabel: UILabel?
    
    var sourceSequenceA: SourceSequenceView! {
        didSet {
            addSubview(sourceSequenceA)
            
            rxOperator.initial.line1.forEach {
                sourceSequenceA.addEventToTimeline($0, animator: sourceSequenceA.animator)
            }
        }
    }
    
    var sourceSequenceB: SourceSequenceView! {
        didSet {
            addSubview(sourceSequenceB)
            
            rxOperator.initial.line2.forEach {
                sourceSequenceB.addEventToTimeline($0, animator: sourceSequenceB.animator)
            }
        }
    }
    
    var resultSequence: ResultSequenceView! {
        didSet {
            addSubview(resultSequence)
        }
    }
    
    var editing: Bool = false {
        didSet {
            resultSequence.editing = editing
            sourceSequenceA?.editing = editing
            sourceSequenceB?.editing = editing
            dimRxOperatorText(editing: editing)
            setNeedsLayout()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(rxOperator: Operator, frame: CGRect) {
        self.rxOperator = rxOperator
        super.init(frame: frame)
        trashView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        setTimelines()
    }
    
    private func setTimelines() {
        addSubview(_rxOperatorLabel)
        _rxOperatorLabel.textAlignment = .center
        _rxOperatorLabel.minimumScaleFactor = 0.5
        _rxOperatorLabel.adjustsFontSizeToFitWidth = true
        _rxOperatorLabel.attributedText = rxOperator.higlightedCode()
        if #available(iOS 13.0, *) {
            _rxOperatorLabel.textColor = .label
        }
        
        addSubview(rxOperatorText)
        rxOperatorText.delegate = self
        rxOperatorText.isEditable = false
        rxOperatorText.isScrollEnabled = false
        rxOperatorText.isUserInteractionEnabled = true
        rxOperatorText.dataDetectorTypes = UIDataDetectorTypes.link
        rxOperatorText.attributedText = rxOperator.linkText
        rxOperatorText.backgroundColor = Color.bgPrimary
        
        resultSequence = ResultSequenceView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 60), rxOperator: rxOperator, sceneView: self)
        if !rxOperator.withoutTimelines {
            sourceSequenceA = SourceSequenceView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 60), scene: self)
            _aLabel = UILabel()
            _aLabel!.text = "a: "
            _aLabel!.font = Font.monospacedRegularText(14)
            addSubview(_aLabel!)
            if rxOperator.multiTimelines {
                _bLabel = UILabel()
                _bLabel!.text = "b: "
                _bLabel!.font = Font.monospacedRegularText(14)
                addSubview(_bLabel!)
                sourceSequenceB = SourceSequenceView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 60), scene: self)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height: CGFloat = 60
        let labelHeight: CGFloat = 40
        let widthSpace: CGFloat = UIApplication.shared.statusBarOrientation.isLandscape ? 40.0 : 20.0
        
        _rxOperatorLabel.frame = CGRect(x: 0, y: 20, width: bounds.width, height: labelHeight)
        if !rxOperator.withoutTimelines {
            sourceSequenceA.frame = CGRect(x: 20, y: 20, width: bounds.width - widthSpace, height: height)
            _rxOperatorLabel.frame.origin.y = sourceSequenceA.frame.origin.y + height
            _aLabel?.frame = CGRect(x: 0, y: sourceSequenceA.frame.origin.y, width: 20, height: height)
            
            if rxOperator.multiTimelines {
                sourceSequenceB.frame = CGRect(x: 20, y: sourceSequenceA.frame.origin.y + sourceSequenceA.frame.height, width: bounds.width - widthSpace, height: height)
                _bLabel?.frame = CGRect(x: 0, y: sourceSequenceB.frame.origin.y, width: 20, height: height)
                _rxOperatorLabel.frame.origin.y = sourceSequenceB.frame.origin.y + height
            }
        }
        resultSequence.frame = CGRect(x: 20, y: _rxOperatorLabel.frame.origin.y + labelHeight + 10, width: bounds.width - widthSpace, height: height)
        
        let size = rxOperatorText.text.boundingRect(with: CGSize(width: bounds.width, height: 1000 ),
                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                    attributes: [.font: rxOperatorText.font!],
                                                    context: nil).size
        rxOperatorText.frame = CGRect(x: 0, y: resultSequence.frame.origin.y + resultSequence.frame.height + 10, width: bounds.width, height: size.height + 40)
        
        if UIApplication.shared.statusBarOrientation.isLandscape && Device.size() < .screen4_7Inch && Device.size() != .unknownSize {
            trashView.center = CGPoint(x: rxOperatorText.center.x, y: UIScreen.main.bounds.height - 60)
        } else {
            trashView.center = rxOperatorText.center
        }
        resultSequence.subject.onNext(())
    }
    
    func showTrashView() {
        addSubview(trashView)
        trashView.isHidden = false
        trashView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        trashView.alpha = 0.05
        trashView.tintColor = Color.trash
        UIView.animate(withDuration: 0.3) { 
            self.rxOperatorText.alpha = 0.04
            self.trashView.alpha = 0.2
            self.trashView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.trashView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func hideTrashView() {
        Animation.hideWithCompletion(trashView) { _ in
            UIView.animate(withDuration: 0.3) { 
                self.rxOperatorText.alpha = 1.0
            }
            self.trashView.removeFromSuperview()
        }
    }
    
    func dimRxOperatorText(editing: Bool) {
        rxOperatorText.isSelectable = !editing
        UIView.animate(withDuration: 0.3) {
            self.rxOperatorText.alpha = editing ? 0.2 : 1.0
        }
    }
    
//    MARK: UITextViewDelegate methods
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        Notifications.openOperatorDescription.post()
        return false
    }
}
