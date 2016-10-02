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
    
    func post(center: NotificationCenter = NotificationCenter.default, object: AnyObject? = nil, userInfo: [AnyHashable: AnyObject]? = nil) {
        center.post(name: NSNotification.Name(rawValue: rawValue), object: object, userInfo: userInfo)
    }

    func rx(center: NotificationCenter = NotificationCenter.default, object: AnyObject? = nil) -> Observable<Notification> {
        return center.rx.notification(Notification.Name(rawValue: rawValue), object: object)
    }
}
