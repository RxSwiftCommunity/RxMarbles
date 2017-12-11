//
//  Font.swift
//  RxMarbles
//
//  Created by Yury Korolev on 2/13/16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import Foundation
import UIKit

enum FontFace: String {
    case monoRegular        = "Menlo-Regular"
    case monoItalic         = "Menlo-Italic"
    case monoBold           = "Menlo-Bold"
    case monoBoldItalic     = "Menlo-BoldItalic"
    case malayalamSangamMN  = "MalayalamSangamMN"
}

struct Font {
    static func code(_ face:FontFace, size: CGFloat) -> UIFont {
        return UIFont(name: face.rawValue, size: size)!
    }
    
    static func text(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
    
    static func boldText(_ size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    static func ultraLightText(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.ultraLight)
    }
    
    static func monospacedRegularText(_ size: CGFloat) -> UIFont {
        return UIFont.monospacedDigitSystemFont(ofSize: size, weight: UIFont.Weight.regular)
    }
}
