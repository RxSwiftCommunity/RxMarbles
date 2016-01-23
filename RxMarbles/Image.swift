//
//  Image.swift
//  RxMarbles
//
//  Created by Yury Korolev on 1/22/16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import Foundation
import UIKit

struct Image {
    static let timeLine = UIImage(named: "timeLine")!
    static let cross    = UIImage(named: "cross")!
    static let trash    = UIImage(named: "Trash")!
    
    static let nextCircle   = UIImage(named: "nextCircle")!.template()
    static let nextTriangle = UIImage(named: "nextTriangle")!.template()
    static let nextRect     = UIImage(named: "nextRect")!.template()
    static let nextStar     = UIImage(named: "nextStar")!.template()
    static let complete     = UIImage(named: "complete")!.template()
    static let error        = UIImage(named: "error")!.template()
}

extension UIImage {
    func template() -> UIImage {
        return imageWithRenderingMode(.AlwaysTemplate)
    }
}