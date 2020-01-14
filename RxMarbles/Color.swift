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

    //Basic colors
    static let black            = hex(0x000000)
    static let white            = hex(0xFFFFFF)
    static let green            = hex(0x007A01)
    static let darkJungleGreen  = hex(0x1E1E1E)

    //Theme colors
    static let bgPrimary        = systemColor(lightModeColor: white, darkModeColor: darkJungleGreen)
    static let label            = systemColor(lightModeColor: black, darkModeColor: white)
    static let nextLightBlue    = systemColor(lightModeColor: hex(0x54C7FC), darkModeColor: hex(0x54C7FC))
    static let nextDarkYellow   = systemColor(lightModeColor: hex(0xFFCD00), darkModeColor: hex(0xFFCD00))
    static let nextGreen        = systemColor(lightModeColor: hex(0x44DB5E), darkModeColor: hex(0x44DB5E))
    static let nextOrange       = systemColor(lightModeColor: hex(0xFF9600), darkModeColor: hex(0xFF9600))
    static let nextBlue         = systemColor(lightModeColor: hex(0x0076FF), darkModeColor: hex(0x0076FF))
    static let nextViolet       = systemColor(lightModeColor: hex(0xBD10E0), darkModeColor: hex(0xBD10E0))
    static let nextLighterBlue  = systemColor(lightModeColor: hex(0x50E3C2), darkModeColor: hex(0x50E3C2))
    static let nextLightGreen   = systemColor(lightModeColor: hex(0xB8E986), darkModeColor: hex(0xB8E986))
    static let nextLightGray    = systemColor(lightModeColor: UIColor.lightGray, darkModeColor: UIColor.lightGray)

    static let codeDefault = systemColor(lightModeColor: black, darkModeColor: black)
    static let codeNumber  = systemColor(lightModeColor: hex(0x1C00CF), darkModeColor: hex(0x1C00CF))
    static let codeMethod  = systemColor(lightModeColor: hex(0x26474B), darkModeColor: hex(0x26474B))
    static let codeKeyword = systemColor(lightModeColor: hex(0xAA0D91), darkModeColor: hex(0xAA0D91))
    static let codeType    = systemColor(lightModeColor: hex(0x3F6E74), darkModeColor: hex(0x3F6E74))

    static let trash = systemColor(lightModeColor: green, darkModeColor: white)
   
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
}

private func hex(_ hex: Int) -> UIColor {
    return rgba(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
}


private func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) -> UIColor {
    assert(red >= 0 && red <= 255,     "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255,   "Invalid blue component")
    
    return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
}

private func systemColor(lightModeColor: UIColor, darkModeColor: UIColor) -> UIColor {
    if #available(iOS 13, *) {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return darkModeColor
            } else {
                return lightModeColor
            }
        }
    } else {
        return lightModeColor
    }
}
