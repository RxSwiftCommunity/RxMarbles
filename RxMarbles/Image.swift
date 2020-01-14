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
    static let timeLine = named("timeLine").withRenderingMode(.alwaysTemplate)
    static let trash    = named("Trash").withRenderingMode(.alwaysTemplate)
    static let rubbish  = named("Rubbish")
    
    static let nextCircle   = named("nextCircle")
    static let nextTriangle = named("nextTriangle")
    static let nextRect     = named("nextRect")
    static let nextStar     = named("nextStar")
    
    static let complete     = named("complete").withRenderingMode(.alwaysTemplate)
    static let error        = named("error").withRenderingMode(.alwaysTemplate)
    
    static let helpLogo     = named("helpLogo")
    static let rxLogo       = named("reactivex")
    
    static let evernote     = named("evernote")
    static let facebook     = named("facebook")
    static let hanghout     = named("hanghout")
    static let mail         = named("mail")
    static let messenger    = named("messenger")
    static let skype        = named("skype")
    static let slack        = named("slack")
    static let trello       = named("trello")
    static let twitter      = named("twitter")
    static let viber        = named("viber")
    static let github       = named("github")
    
    static let cross        = named("cross")
    
    static let anjlab       = named("anjlab")
    static let ellipse1     = named("anjlab_ellipse1")
    static let ellipse2     = named("anjlab_ellipse2")
    
    static let navBarShare          = named("navBarShare")

    static let navBarExperiment     = named("navBarExperiment")
    static let timelineExperiment   = named("timelineExperiment")
    
    static let upArrow      = named("upArrow")
    static let downArrow    = named("downArrow")
}

private func named(_ name: String) -> UIImage {
   return UIImage(named: name)!
}

extension UIImage {
    func imageView() -> UIImageView {
        return UIImageView(image: self)
    }
}
