//
//  EventShape.swift
//  RxMarbles
//
//  Created by Yury Korolev on 1/22/16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import UIKit

private var __coloredImages = [String: UIImage]()

enum EventShape: String {
    case Circle
    case Rect
    case Triangle
    case Star
    case None
    
    var image: UIImage {
        switch self {
        case Circle:   return Image.nextCircle
        case Rect:     return Image.nextRect
        case Triangle: return Image.nextTriangle
        case Star:     return Image.nextStar
        case None:     return UIImage()
        }
    }
    
    func image(color: UIColor) -> UIImage {
        let key = "\(color.description)-\(self)"
        
        if let res = __coloredImages[key] {
            return res
        }
        
        let grayscaleImg = image
        let size = 16 as CGFloat
        let rect = CGRectMake(0, 0, size, size)
        
        UIGraphicsBeginImageContextWithOptions(grayscaleImg.size, false, grayscaleImg.scale)
        
        let c = UIGraphicsGetCurrentContext()
        
        grayscaleImg.drawInRect(rect, blendMode: .Normal, alpha: 1.0)
        
        CGContextScaleCTM(c, 1.0, -1.0);
        let r = CGRectMake(0, -size, size, size)
        CGContextClipToMask(c, r, grayscaleImg.CGImage)
    
        color.setFill()
        
        UIRectFillUsingBlendMode(r, CGBlendMode.Color)
        
        let res = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        __coloredImages[key] = res
        return res
    }
}


