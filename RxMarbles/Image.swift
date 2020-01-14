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
    static let timeLine = _named("timeLine").withRenderingMode(.alwaysTemplate)
    static let trash    = _named("Trash").withRenderingMode(.alwaysTemplate)
    static let rubbish  = _named("Rubbish")
    
    static let nextCircle   = _named("nextCircle")
    static let nextTriangle = _named("nextTriangle")
    static let nextRect     = _named("nextRect")
    static let nextStar     = _named("nextStar")
    
    static let complete     = _named("complete").withRenderingMode(.alwaysTemplate)
    static let error        = _named("error").withRenderingMode(.alwaysTemplate)
    
    static let helpLogo     = _named("helpLogo")
    static let rxLogo       = _named("reactivex")
    
    static let evernote     = _named("evernote")
    static let facebook     = _named("facebook")
    static let hanghout     = _named("hanghout")
    static let mail         = _named("mail")
    static let messenger    = _named("messenger")
    static let skype        = _named("skype")
    static let slack        = _named("slack")
    static let trello       = _named("trello")
    static let twitter      = _named("twitter")
    static let viber        = _named("viber")
    static let github       = _named("github")
    
    static let cross        = _named("cross")
    
    static let anjlab       = _named("anjlab")
    static let ellipse1     = _named("anjlab_ellipse1")
    static let ellipse2     = _named("anjlab_ellipse2")
    
    static let navBarShare          = _named("navBarShare")

    static let navBarExperiment     = _named("navBarExperiment")
    static let timelineExperiment   = _named("timelineExperiment")
    
    static let upArrow      = _named("upArrow")
    static let downArrow    = _named("downArrow")
}

private func _named(_ name: String) -> UIImage {
   return UIImage(named: name)!
}

extension UIImage {
    func imageView() -> UIImageView {
        return UIImageView(image: self)
    }
}
