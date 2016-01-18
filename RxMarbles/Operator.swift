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
    case Buffer
    case FlatMap
    case FlatMapFirst
    case CombineLatest
    case Concat
    case Merge
    case Zip
    case StartWith
    case DistinctUntilChanged
    case ElementAt
    case Filter
    case IgnoreElements
    case Sample
    case Skip
    case Take
    case TakeLast
    case Reduce
    case Amb
}

extension Operator: CustomStringConvertible {
    var description: String {
        switch self {
        case Delay:                return "Delay"
        case Map:                  return "Map"
        case Scan:                 return "Scan"
        case Debounce:             return "Debounce"
        case Buffer:               return "Buffer"
        case FlatMap:              return "FlatMap"
        case FlatMapFirst:         return "FlatMapFirst"
        case CombineLatest:        return "CombineLatest"
        case Concat:               return "Concat"
        case Merge:                return "Merge"
        case Zip:                  return "Zip"
        case StartWith:            return "StartWith"
        case DistinctUntilChanged: return "DistinctUntilChanged"
        case ElementAt:            return "ElementAt"
        case Filter:               return "Filter"
        case IgnoreElements:       return "IgnoreElements"
        case Sample:               return "Sample"
        case Skip:                 return "Skip"
        case Take:                 return "Take"
        case TakeLast:             return "TakeLast"
        case Reduce:               return "Reduce"
        case Amb:                  return "Amb"
        }
    }
}

extension Operator {
    func map(o: (first: TestableObservable<ColoredType>, second: TestableObservable<ColoredType>?), scheduler: TestScheduler) -> Observable<ColoredType> {
        switch self {
        case Delay:                return o.first.delaySubscription(30, scheduler: scheduler)
        case Map:                  return o.first.map({ h in ColoredType(value: h.value * 10, color: h.color, shape: h.shape) })
        case Scan:                 return o.first.scan(ColoredType(value: 0, color: .redColor(), shape: .Circle), accumulator: { acc, e in
            var res = acc
            res.value += e.value
            res.color = e.color
            return res
        })
        case Debounce:             return o.first.debounce(50, scheduler: scheduler)
        case Buffer:               return o.first.buffer(timeSpan: 100, count: 3, scheduler: scheduler).map({ event in ColoredType(value: 13, color: .redColor(), shape: .Circle) })
        case FlatMap:              return o.first.flatMap({ event in return o.second! })
        case FlatMapFirst:         return o.first.flatMapFirst({ event in return o.second! })
        case CombineLatest:        return [o.first, o.second!].combineLatest({ event in
            let res = ColoredType(value: ((event.first?.value)! + (event.last?.value)!), color: (event.first?.color)!, shape: (event.first?.shape)!)
            return res
        })
        case Concat:               return [o.first, o.second!].concat()
        case Merge:                return Observable.of(o.first, o.second!).merge()
        case Zip:                  return [o.first, o.second!].zip({ event in
            let res = ColoredType(value: ((event.first?.value)! + (event.last?.value)!), color: (event.first?.color)!, shape: (event.first?.shape)!)
            return res
        })
        case StartWith:            return o.first.startWith(ColoredType(value: 2, color: .redColor(), shape: .Circle))
        case DistinctUntilChanged: return o.first.distinctUntilChanged()
        case ElementAt:            return o.first.elementAt(2)
        case Filter:               return o.first.filter { $0.value > 2 }
        case IgnoreElements:       return o.first.ignoreElements()
        case Sample:               return o.first.ignoreElements()//scheduler.start({o.first.sample(o.second)})
        case Skip:                 return o.first.skip(2)
        case Take:                 return o.first.take(2)
        case TakeLast:             return o.first.takeLast(2)
        case Reduce:
            return o.first.reduce(ColoredType(value: 0, color: .redColor(), shape: .Circle), accumulator: { acc, e in
                var res = acc
                res.value += e.value
                res.color = e.color
                res.shape = e.shape
                return res
            })
        case Amb:                   return o.first.ignoreElements()
        }
    }
}

extension Operator {
    var multiTimelines: Bool {
        switch self {
        case Delay:                return false
        case Map:                  return false
        case Scan:                 return false
        case Debounce:             return false
        case Buffer:               return false
        case FlatMap:              return true
        case FlatMapFirst:         return true
        case CombineLatest:        return true
        case Concat:               return true
        case Merge:                return true
        case Zip:                  return true
        case StartWith:            return false
        case DistinctUntilChanged: return false
        case ElementAt:            return false
        case Filter:               return false
        case IgnoreElements:       return false
        case Sample:               return true
        case Skip:                 return false
        case Take:                 return false
        case TakeLast:             return false
        case Reduce:               return false
        case Amb:                  return true
        }
    }
}