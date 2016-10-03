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
    case circle
    case rect
    case triangle
    case star
    case none
    
    var image: UIImage {
        switch self {
        case .circle:   return RxMarbles.Image.nextCircle
        case .rect:     return RxMarbles.Image.nextRect
        case .triangle: return RxMarbles.Image.nextTriangle
        case .star:     return RxMarbles.Image.nextStar
        case .none:     return UIImage()
        }
    }
    
    func image(_ color: UIColor) -> UIImage {
        let key = "\(color.description)-\(self)"
        
        if let res = __coloredImages[key] {
            return res
        }
        
        let grayscaleImg = image
        let size = 16 as CGFloat
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        
        UIGraphicsBeginImageContextWithOptions(grayscaleImg.size, false, grayscaleImg.scale)
        defer { UIGraphicsEndImageContext() }
        
        let c = UIGraphicsGetCurrentContext()!
        
        grayscaleImg.draw(in: rect, blendMode: .normal, alpha: 1.0)
        
        c.scaleBy(x: 1.0, y: -1.0)
        let r = CGRect(x: 0, y: -size, width: size, height: size)
        c.clip(to: r, mask: grayscaleImg.cgImage!)
    
        color.setFill()
        
        UIRectFillUsingBlendMode(r, CGBlendMode.color)
        
        let res = UIGraphicsGetImageFromCurrentImageContext()!
        
        
        __coloredImages[key] = res
        return res
    }
}


