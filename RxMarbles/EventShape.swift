//
//  EventShape.swift
//  RxMarbles
//
//  Created by Yury Korolev on 1/22/16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import Foundation
import UIKit

enum EventShape {
    case Circle
    case Rect
    case Triangle
    case Star
    case None
    
    var image: UIImage {
        switch self {
        case Circle:
            return Image.nextCircle
        case Rect:
            return Image.nextRect
        case Triangle:
            return Image.nextTriangle
        case Star:
            return Image.nextStar
        case None:
            return UIImage()
        }
    }
}


