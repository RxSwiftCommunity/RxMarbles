//
//  Names.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 19.02.16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum Notifications: String {
    case setEventView
    case addEvent
    case openOperatorDescription
    case hideHelpWindow
    
    func post(center: NSNotificationCenter = NSNotificationCenter.defaultCenter(), object: AnyObject? = nil, userInfo: [NSObject: AnyObject]? = nil) {
        center.postNotificationName(rawValue, object: object, userInfo: userInfo)
    }

    func rx(center: NSNotificationCenter = NSNotificationCenter.defaultCenter(), object: AnyObject? = nil) -> Observable<NSNotification> {
        return center.rx_notification(rawValue, object: object)
    }
}