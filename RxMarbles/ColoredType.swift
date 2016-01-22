//
//  ColoredType.swift
//  RxMarbles
//
//  Created by Yury Korolev on 1/22/16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import Foundation
import UIKit

struct ColoredType: Equatable {
    var value: String
    var color: UIColor
    var shape: EventShape
}

func ==(lhs: ColoredType, rhs: ColoredType) -> Bool {
    return lhs.value == rhs.value && lhs.color == rhs.color && lhs.shape == rhs.shape
}