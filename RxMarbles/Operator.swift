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
    case CombineLatest
    case Concat
    case Zip
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
        case CombineLatest:        return "CombineLatest"
        case Concat:               return "Concat"
        case Zip:                  return "Zip"
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
    func map(o: (first: TestableObservable<ColoredType>, second: TestableObservable<ColoredType>?), scheduler: TestScheduler) -> Observable<ColoredType> {
        switch self {
        case Delay:                return o.first.delaySubscription(30, scheduler: scheduler)
        case Map:                  return o.first.map({ h in ColoredType(value: h.value * 10, color: h.color) })
        case Scan:                 return o.first.scan(ColoredType(value: 0, color: .redColor()), accumulator: { acc, e in
            var res = acc
            res.value += e.value
            res.color = e.color
            return res
        })
        case Debounce:             return o.first.debounce(50, scheduler: scheduler)
        case CombineLatest:        return [o.first, o.second!].combineLatest({ event in
            let res = ColoredType(value: ((event.first?.value)! + (event.last?.value)!), color: (event.first?.color)!)
            return res
        })
        case Concat:               return [o.first, o.second!].concat()
        case Zip:                  return [o.first, o.second!].zip({ event in
            let res = ColoredType(value: ((event.first?.value)! + (event.last?.value)!), color: (event.first?.color)!)
            return res
        })
        case StartWith:            return o.first.startWith(ColoredType(value: 2, color: RXMUIKit.randomColor()))
        case DistinctUntilChanged: return o.first.distinctUntilChanged()
        case ElementAt:            return o.first.elementAt(2)
        case Filter:               return o.first.filter { $0.value > 2 }
        case Skip:                 return o.first.skip(2)
        case Take:                 return o.first.take(2)
        case TakeLast:             return o.first.takeLast(2)
        case Reduce:
            return o.first.reduce(ColoredType(value: 0, color: .redColor()), accumulator: { acc, e in
                var res = acc
                res.value += e.value
                res.color = e.color
                return res
            })
        }
    }
}