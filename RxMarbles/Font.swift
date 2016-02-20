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
    case MonoRegular        = "Menlo-Regular"
    case MonoItalic         = "Menlo-Italic"
    case MonoBold           = "Menlo-Bold"
    case MonoBoldItalic     = "Menlo-BoldItalic"
    case MalayalamSangamMN  = "MalayalamSangamMN"
}

struct Font {
    static func code(face:FontFace, size: CGFloat) -> UIFont {
        return UIFont(name: face.rawValue, size: size)!
    }
    
    static func text(size: CGFloat) -> UIFont {
        return UIFont.systemFontOfSize(size)
    }
    
    static func boldText(size: CGFloat) -> UIFont {
        return UIFont.boldSystemFontOfSize(size)
    }
}