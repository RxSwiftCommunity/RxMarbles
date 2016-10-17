//
//  Color.swift
//  RxMarbles
//
//  Created by Yury Korolev on 1/22/16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import Foundation
import UIKit

struct Color {
    static let nextLightBlue    = _hex(0x54C7FC)
    static let nextDarkYellow   = _hex(0xFFCD00)
    static let nextGreen        = _hex(0x44DB5E)
    static let nextOrange       = _hex(0xFF9600)
    static let nextBlue         = _hex(0x0076FF)
    static let nextViolet       = _hex(0xBD10E0)
    static let nextLighterBlue  = _hex(0x50E3C2)
    static let nextLightGreen   = _hex(0xB8E986)
    static let nextLightGray    = UIColor.lightGray
    
    static let black            = _hex(0x000000)
    static let white            = _hex(0xFFFFFF)
   
    static var nextAll: [UIColor] {
        return [
            Color.nextLightBlue, Color.nextDarkYellow, Color.nextGreen,
            Color.nextOrange, Color.nextBlue, Color.nextViolet, Color.nextLightBlue,
            Color.nextLightGreen, Color.nextLightGray
        ]
    }
    
    static var nextRandom: UIColor {
        var allColors = nextAll
        allColors.removeLast()
        return allColors[Int(arc4random() % UInt32(allColors.count))]
    }
    
    
    static let codeDefault = black
    static let codeNumber  = _hex(0x1C00CF)
    static let codeMethod  = _hex(0x26474B)
    static let codeKeyword = _hex(0xAA0D91)
    static let codeType    = _hex(0x3F6E74)
}

private func _hex(_ hex: Int) -> UIColor {
    return _rgba(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
}


private func _rgba(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) -> UIColor {
    assert(red >= 0 && red <= 255,     "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255,   "Invalid blue component")
    
    return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
}
