//
//  ColoredType.swift
//  RxMarbles
//
//  Created by Yury Korolev on 1/22/16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

struct ColoredType: Equatable {
    var value: String
    var color: UIColor
    var shape: EventShape
}

func ==(lhs: ColoredType, rhs: ColoredType) -> Bool {
    return lhs.value == rhs.value && lhs.shape == rhs.shape
}

typealias RecordedType = Recorded<Event<ColoredType>>

// Helper functions
func next(_ time: Int, _ value: String, _ color: UIColor, _ shape: EventShape) -> RecordedType {
    return RecordedType(time: time, value: Event.next(ColoredType(value: value, color: color, shape: shape)))
}

func completed(_ time: Int) -> RecordedType {
    return RecordedType(time: time, value: .completed)
}

func error(_ time: Int) -> RecordedType {
    return RecordedType(time: time, value: Event.error(RxError.unknown))
}
