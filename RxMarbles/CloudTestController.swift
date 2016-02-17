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
    
    let _monoBoldItalicLabel = UILabel()
    let _monoBoldLabel = UILabel()
    let _monoRegularLabel = UILabel()
    let _monoItalicLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(_monoBoldItalicLabel)
        
        let (mBoldItalic, mBold, mRegular, mItalic) = _operatorsCloud()
    
        _monoBoldItalicLabel.numberOfLines = 0
        _monoBoldItalicLabel.attributedText = mBoldItalic
        
        view.addSubview(_monoBoldLabel)
        
        _monoBoldLabel.numberOfLines = 0
        _monoBoldLabel.attributedText = mBold
        
        view.addSubview(_monoRegularLabel)
        
        _monoRegularLabel.numberOfLines = 0
        _monoRegularLabel.attributedText = mRegular
        
        view.addSubview(_monoItalicLabel)
        
        _monoItalicLabel.numberOfLines = 0
        _monoItalicLabel.attributedText = mItalic

        _addMotionEffectToView(_monoBoldItalicLabel, relativity: (vertical: (min: -10, max: 10), horizontal: (min: -10, max: 10)))
        _addMotionEffectToView(_monoBoldLabel, relativity: (vertical: (min: 10, max: -10), horizontal: (min: 10, max: -10)))
        _addMotionEffectToView(_monoRegularLabel, relativity: (vertical: (min: -10, max: -10), horizontal: (min: -10, max: -10)))
        _addMotionEffectToView(_monoItalicLabel, relativity: (vertical: (min: 10, max: 10), horizontal: (min: 10, max: 10)))
    }
    
    private func _addMotionEffectToView(view: UIView, relativity: (vertical: (min: AnyObject, max: AnyObject), horizontal: (min: AnyObject, max: AnyObject))) {
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y",
            type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = relativity.vertical.min
        verticalMotionEffect.maximumRelativeValue = relativity.vertical.max
        
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x",
            type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = relativity.horizontal.min
        horizontalMotionEffect.maximumRelativeValue = relativity.horizontal.max
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [verticalMotionEffect, horizontalMotionEffect]
        
        view.addMotionEffect(group)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        _monoBoldItalicLabel.frame = view.bounds
        _monoBoldLabel.frame = view.bounds
        _monoRegularLabel.frame = view.bounds
    }
    
    func _operatorsCloud() -> (mBoldItalic: NSMutableAttributedString, mBold: NSMutableAttributedString, mRegular: NSMutableAttributedString, mItalic: NSMutableAttributedString) {
        let monoBoldItalicString = NSMutableAttributedString()
        let monoBoldString = NSMutableAttributedString()
        let monoRegularString = NSMutableAttributedString()
        let monoItalicString = NSMutableAttributedString()
        let p = NSMutableParagraphStyle()
        p.lineBreakMode = .ByWordWrapping
        p.lineSpacing = 9.2
        p.alignment = .Center
        
        let allOperators = Operator.all.shuffle()
        
        var i = 0
        
        for op in allOperators[0...23] {
            let rnd = random() % 3
            
            let operatorString = _attributedOperatorString(op, p: p, rnd: rnd)
            let alphaString = NSMutableAttributedString(attributedString: operatorString)
            alphaString.addAttributes([NSForegroundColorAttributeName : UIColor.clearColor()], range: NSMakeRange(0, operatorString.length))
            switch rnd {
            case 0:
                monoBoldItalicString.appendAttributedString(operatorString)
                monoBoldString.appendAttributedString(alphaString)
                monoRegularString.appendAttributedString(alphaString)
                monoItalicString.appendAttributedString(alphaString)
            case 1:
                monoBoldItalicString.appendAttributedString(alphaString)
                monoBoldString.appendAttributedString(operatorString)
                monoRegularString.appendAttributedString(alphaString)
                monoItalicString.appendAttributedString(alphaString)
            case 2:
                monoBoldItalicString.appendAttributedString(alphaString)
                monoBoldString.appendAttributedString(alphaString)
                monoRegularString.appendAttributedString(operatorString)
                monoItalicString.appendAttributedString(alphaString)
            case 3:
                monoBoldItalicString.appendAttributedString(alphaString)
                monoBoldString.appendAttributedString(alphaString)
                monoRegularString.appendAttributedString(alphaString)
                monoItalicString.appendAttributedString(operatorString)
            default:
                break
            }
            
            if i == 0 {
                monoBoldItalicString.appendAttributedString(NSAttributedString(string: "\n"))
                monoBoldString.appendAttributedString(NSAttributedString(string: "\n"))
                monoRegularString.appendAttributedString(NSAttributedString(string: "\n"))
                monoItalicString.appendAttributedString(NSAttributedString(string: "\n"))
            } else {
                monoBoldItalicString.appendAttributedString(NSAttributedString(string: " "))
                monoBoldString.appendAttributedString(NSAttributedString(string: " "))
                monoRegularString.appendAttributedString(NSAttributedString(string: " "))
                monoItalicString.appendAttributedString(NSAttributedString(string: " "))
            }
            
            i += 1
        }
        
        return (mBoldItalic: monoBoldItalicString, mBold: monoBoldString, mRegular: monoRegularString, mItalic: monoItalicString)
    }
    
    private func _attributedOperatorString(op: Operator, p: NSMutableParagraphStyle, rnd: Int) -> NSMutableAttributedString {

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