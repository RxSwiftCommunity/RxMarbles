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
    
    let _label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(_label)
    
        _label.numberOfLines = 0
        _label.attributedText = _operatorsCloud()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        _label.frame = view.bounds
    }
    
    func _operatorsCloud() -> NSAttributedString {
        let res = NSMutableAttributedString()
        let p = NSMutableParagraphStyle()
        p.lineBreakMode = .ByWordWrapping
        p.lineSpacing = 9.2
        p.alignment = .Center
        
        let allOperators = Operator.all.shuffle()
        
        var i = 0
        
        for op in allOperators[0...23] {
            let rnd = random() % 3
            
            switch rnd {
            case 0:
                res.appendAttributedString(
                    NSAttributedString(string: op.rawValue, attributes: [
                        NSFontAttributeName: Font.code(.MonoBoldItalic, size: 15),
                        NSParagraphStyleAttributeName: p
                        ])
                )
            case 1:
                res.appendAttributedString(
                    NSAttributedString(string: op.rawValue, attributes: [
                        NSFontAttributeName: Font.code(.MonoBold, size: 13),
                        NSParagraphStyleAttributeName: p
                    ])
                )
            case 2:
                res.appendAttributedString(
                    NSAttributedString(string: op.rawValue, attributes: [
                        NSFontAttributeName: Font.code(.MonoRegular, size: 13),
                        NSParagraphStyleAttributeName: p
                        ])
                )
            case 3:
                res.appendAttributedString(
                    NSAttributedString(string: op.rawValue, attributes: [
                        NSFontAttributeName: Font.code(.MonoItalic, size: 12),
                        NSParagraphStyleAttributeName: p
                        ])
                )
            default:
                res.appendAttributedString(
                    NSAttributedString(string: op.rawValue, attributes: [
                        NSFontAttributeName: Font.code(.MonoRegular, size: 11),
                        NSParagraphStyleAttributeName: p
                        ])
                )
            }
            
            if i == 0 {
                res.appendAttributedString(NSAttributedString(string: "\n"))
            } else {
                res.appendAttributedString(NSAttributedString(string: " "))
            }
            
            i += 1
        }
        
        return res
    }
}