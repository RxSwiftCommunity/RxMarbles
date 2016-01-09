//
//  RXMUIKit.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 09.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit

class RXMUIKit: NSObject {
    
    static func lightBlueColor() -> UIColor {
        return UIColor(red: 84/255, green: 199/255, blue: 252/255, alpha: 1.0)
    }
    
    static func darkYellowColor() -> UIColor {
        return UIColor(red: 1.0, green: 205/255, blue: 0.0, alpha: 1.0)
    }
    
    static func lightGreenColor() -> UIColor {
        return UIColor(red: 68/255, green: 219/255, blue: 94/255, alpha: 1.0)
    }
    
    static func blueColor() -> UIColor {
        return UIColor(red: 0.0, green: 118/255, blue: 1.0, alpha: 1.0)
    }
    
    static func orangeColor() -> UIColor {
        return UIColor(red: 1.0, green: 150/255, blue: 0.0, alpha: 1.0)
    }
    
    static func randomColor() -> UIColor {
        let random = Int(arc4random_uniform(5) + 1)
        switch random {
        case 1:
            return lightBlueColor()
        case 2:
            return darkYellowColor()
        case 3:
            return lightGreenColor()
        case 4:
            return blueColor()
        case 5:
            return orangeColor()
        default:
            return lightGreenColor()
        }
    }
}
