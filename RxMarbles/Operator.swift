//
//  Operator.swift
//  RxMarbles
//
//  Created by Yury Korolev on 1/10/16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import Foundation
import RxSwift

enum Operator {
    case Delay
    case Map
    case Scan
    case Debounce
    case StartWith
    case DistinctUntilChanged
    case ElementAt
    case Filter
    case Skip
    case Take
    case TakeLast
    case Reduce
}

extension Operator: CustomStringConvertible {
    var description: String {
        switch self {
        case Delay:                return "Delay"
        case Map:                  return "Map"
        case Scan:                 return "Scan"
        case Debounce:             return "Debounce"
        case StartWith:            return "StartWith"
        case DistinctUntilChanged: return "DistinctUntilChanged"
        case ElementAt:            return "ElementAt"
        case Filter:               return "Filter"
        case Skip:                 return "Skip"
        case Take:                 return "Take"
        case TakeLast:             return "TakeLast"
        case Reduce:               return "Reduce"
        }
    }
}

extension Operator {
    func map(o: Observable<ColoredType>, scheduler: TestScheduler) -> Observable<ColoredType> {
        switch self {
        case Delay:                return o.delaySubscription(30, scheduler: scheduler)
        case Map:                  return o.map({ h in ColoredType(value: h.value * 10, color: h.color) })
        case Scan:                 return o.scan(ColoredType(value: 0, color: .redColor()), accumulator: { acc, e in
            var res = acc
            res.value += e.value
            res.color = e.color
            return res
        })
        case Debounce:             return o.debounce(50, scheduler: scheduler)
        case StartWith:            return o.startWith(ColoredType(value: 2, color: RXMUIKit.randomColor()))
        case DistinctUntilChanged: return o.distinctUntilChanged()
        case ElementAt:            return o.elementAt(2)
        case Filter:               return o.filter { $0.value > 2 }
        case Skip:                 return o.skip(2)
        case Take:                 return o.take(2)
        case TakeLast:             return o.takeLast(2)
        case Reduce:
            return o.reduce(ColoredType(value: 0, color: .redColor()), accumulator: { acc, e in
                var res = acc
                res.value += e.value
                res.color = e.color
                return res
            })
        }
    }
}