//
//  CloudTestController.swift
//  RxMarbles
//
//  Created by Yury Korolev on 2/15/16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import Foundation
import UIKit

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

class CloudTestController: UIViewController {
    
    let _bottomLabel = UILabel()
    let _middleLabel = UILabel()
    let _topLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(_bottomLabel)
        
        let (bottom, mid, top) = _operatorsCloud()
    
        _bottomLabel.numberOfLines = 0
        _bottomLabel.attributedText = bottom
        
        view.addSubview(_middleLabel)
        
        _middleLabel.numberOfLines = 0
        _middleLabel.attributedText = mid
        
        view.addSubview(_topLabel)
        
        _topLabel.numberOfLines = 0
        _topLabel.attributedText = top

        _addMotionEffectToView(_bottomLabel, relatitivity: (vertical: (min: -10, max: 10), horizontal: (min: -10, max: 10)))
        _addMotionEffectToView(_middleLabel, relatitivity: (vertical: (min: 10, max: -10), horizontal: (min: 10, max: -10)))
        _addMotionEffectToView(_topLabel, relatitivity: (vertical: (min: -10, max: -10), horizontal: (min: -10, max: -10)))
    }
    
    private func _addMotionEffectToView(view: UIView, relatitivity: (vertical: (min: AnyObject, max: AnyObject), horizontal: (min: AnyObject, max: AnyObject))) {
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y",
            type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = relatitivity.vertical.min
        verticalMotionEffect.maximumRelativeValue = relatitivity.vertical.max
        
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x",
            type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = relatitivity.horizontal.min
        horizontalMotionEffect.maximumRelativeValue = relatitivity.horizontal.max
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [verticalMotionEffect, horizontalMotionEffect]
        
        view.addMotionEffect(group)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        _bottomLabel.frame = view.bounds
        _middleLabel.frame = view.bounds
        _topLabel.frame = view.bounds
    }
    
    func _operatorsCloud() -> (bottom: NSMutableAttributedString, mid: NSMutableAttributedString, top: NSMutableAttributedString) {
        let bottom = NSMutableAttributedString()
        let mid = NSMutableAttributedString()
        let top = NSMutableAttributedString()
        let p = NSMutableParagraphStyle()
        p.lineBreakMode = .ByWordWrapping
        p.lineSpacing = 9.2
        p.alignment = .Center
        
        let allOperators = Operator.all.shuffle()
        
        var i = 0
        
        for op in allOperators[0...23] {
            let levelRnd = random() % 2
            
            let operatorString = _attributedOperatorString(op, p: p)
            let alphaString = NSMutableAttributedString(attributedString: operatorString)
            alphaString.addAttributes([NSForegroundColorAttributeName : UIColor.clearColor()], range: NSMakeRange(0, operatorString.length))
            switch levelRnd {
            case 0:
                bottom.appendAttributedString(operatorString)
                mid.appendAttributedString(alphaString)
                top.appendAttributedString(alphaString)
            case 1:
                bottom.appendAttributedString(alphaString)
                mid.appendAttributedString(operatorString)
                top.appendAttributedString(alphaString)
            case 2:
                bottom.appendAttributedString(alphaString)
                mid.appendAttributedString(alphaString)
                top.appendAttributedString(operatorString)
            default:
                break
            }
            
            if i == 0 {
                bottom.appendAttributedString(NSAttributedString(string: "\n"))
                mid.appendAttributedString(NSAttributedString(string: "\n"))
                top.appendAttributedString(NSAttributedString(string: "\n"))
            } else {
                bottom.appendAttributedString(NSAttributedString(string: " "))
                mid.appendAttributedString(NSAttributedString(string: " "))
                top.appendAttributedString(NSAttributedString(string: " "))
            }
            
            i += 1
        }
        
        return (bottom: bottom, mid: mid, top: top)
    }
    
    private func _attributedOperatorString(op: Operator, p: NSMutableParagraphStyle) -> NSMutableAttributedString {
        let rnd = random() % 3
        
        switch rnd {
        case 0:
            return NSMutableAttributedString(string: op.rawValue, attributes: [
                NSFontAttributeName: Font.code(.MonoBoldItalic, size: 15),
                NSParagraphStyleAttributeName: p
                ])
        case 1:
            return NSMutableAttributedString(string: op.rawValue, attributes: [
                NSFontAttributeName: Font.code(.MonoBold, size: 13),
                NSParagraphStyleAttributeName: p
                ])
        case 2:
            return NSMutableAttributedString(string: op.rawValue, attributes: [
                NSFontAttributeName: Font.code(.MonoRegular, size: 13),
                NSParagraphStyleAttributeName: p
                ])
        case 3:
            return NSMutableAttributedString(string: op.rawValue, attributes: [
                NSFontAttributeName: Font.code(.MonoItalic, size: 12),
                NSParagraphStyleAttributeName: p
                ])
        default:
            return NSMutableAttributedString(string: op.rawValue, attributes: [
                NSFontAttributeName: Font.code(.MonoRegular, size: 11),
                NSParagraphStyleAttributeName: p
                ])
        }
    }
}