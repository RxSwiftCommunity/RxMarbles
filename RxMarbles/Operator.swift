//
//  Operator.swift
//  RxMarbles
//
//  Created by Yury Korolev on 1/10/16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import Foundation
import RxSwift
import CoreSpotlight

enum Error: ErrorType {
    case CantParseStringToInt
}

enum Operator {
    case Amb
    case Buffer
    case CombineLatest
    case Concat
    case Debounce
    case Delay
    case DistinctUntilChanged
    case ElementAt
    case Filter
    case FlatMap
    case FlatMapFirst
    case FlatMapLatest
    case IgnoreElements
    case Map
    case Merge
    case Reduce
    case Sample
    case Scan
    case Skip
    case StartWith
    case Take
    case TakeLast
    case Zip
}

extension Operator: CustomStringConvertible {
    var description: String {
        switch self {
        case Amb:                  return "Amb"
        case Buffer:               return "Buffer"
        case CombineLatest:        return "CombineLatest"
        case Concat:               return "Concat"
        case Debounce:             return "Debounce"
        case Delay:                return "Delay"
        case DistinctUntilChanged: return "DistinctUntilChanged"
        case ElementAt:            return "ElementAt"
        case Filter:               return "Filter"
        case FlatMap:              return "FlatMap"
        case FlatMapFirst:         return "FlatMapFirst"
        case FlatMapLatest:        return "FlatMapLatest"
        case IgnoreElements:       return "IgnoreElements"
        case Map:                  return "Map"
        case Merge:                return "Merge"
        case Reduce:               return "Reduce"
        case Sample:               return "Sample"
        case Scan:                 return "Scan"
        case Skip:                 return "Skip"
        case StartWith:            return "StartWith"
        case Take:                 return "Take"
        case TakeLast:             return "TakeLast"
        case Zip:                  return "Zip"
        }
    }
}

extension Operator {
    func map(o: (first: TestableObservable<ColoredType>, second: TestableObservable<ColoredType>?), scheduler: TestScheduler) -> Observable<ColoredType> {
        switch self {
        case Delay:                return o.first.delaySubscription(30, scheduler: scheduler)
        case Map:                  return o.first.map({ h in
            guard let a = Int(h.value) else { throw Error.CantParseStringToInt }
            return ColoredType(value: String(a * 10), color: h.color, shape: h.shape)
        })
        case Scan:                 return o.first.scan(ColoredType(value: String(0), color: .redColor(), shape: o.first.recordedEvents.first?.value.element?.shape != nil ? (o.first.recordedEvents.first?.value.element?.shape)! : .Another), accumulator: { acc, e in
            var res = acc
            guard let a = Int(e.value),
                  let b = Int(res.value) else { throw Error.CantParseStringToInt }
            res.value = String(a + b)
            res.color = e.color
            res.shape = e.shape
            return res
        })
        case Debounce:             return o.first.debounce(50, scheduler: scheduler)
        case Buffer:               return o.first.buffer(timeSpan: 100, count: 3, scheduler: scheduler).map({ event in ColoredType(value: "13", color: .redColor(), shape: .Rhombus) })
        case FlatMap:              return o.first.flatMap({ event in return o.second! })
        case FlatMapFirst:         return o.first.flatMapFirst({ event in return o.second! })
        case FlatMapLatest:        return o.first.flatMapLatest({ event in return o.second! })
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
        case StartWith:            return o.first.startWith(ColoredType(value: "2", color: .redColor(), shape: .Circle))
        case DistinctUntilChanged: return o.first.distinctUntilChanged()
        case ElementAt:            return o.first.elementAt(2)
        case Filter:               return o.first.filter {
            guard let a = Int($0.value) else { throw Error.CantParseStringToInt }
            return a > 5
        }
        case IgnoreElements:       return o.first.ignoreElements()
        case Sample:               return o.first.sample(o.second!)
        case Skip:                 return o.first.skip(2)
        case Take:                 return o.first.take(2)
        case TakeLast:             return o.first.takeLast(2)
        case Reduce:
            return o.first.reduce(ColoredType(value: "0", color: .redColor(), shape: o.first.recordedEvents.first?.value.element?.shape != nil ? (o.first.recordedEvents.first?.value.element?.shape)! : .Another), accumulator: { acc, e in
                var res = acc
                guard let a = Int(e.value),
                      let b = Int(res.value) else { throw Error.CantParseStringToInt }
                res.value = String(a + b)
                res.color = e.color
                res.shape = e.shape
                return res
            })
        case Amb:                  return o.first.amb(o.second!)
        }
    }
}

extension Operator {
    var multiTimelines: Bool {
        switch self {
        case Amb:                  return true
        case Buffer:               return false
        case CombineLatest:        return true
        case Concat:               return true
        case Debounce:             return false
        case Delay:                return false
        case DistinctUntilChanged: return false
        case ElementAt:            return false
        case Filter:               return false
        case FlatMap:              return true
        case FlatMapFirst:         return true
        case FlatMapLatest:        return true
        case IgnoreElements:       return false
        case Map:                  return false
        case Merge:                return true
        case Reduce:               return false
        case Sample:               return true
        case Scan:                 return false
        case Skip:                 return false
        case StartWith:            return false
        case Take:                 return false
        case TakeLast:             return false
        case Zip:                  return true
        }
    }
}

extension Operator {
    func userActivity() -> NSUserActivity {
        let activity = NSUserActivity(activityType: "https://anjlab.com/rx/\(self.description)")
        activity.title = description
        activity.keywords = ["Rx", "Reactive", "Operator", "Marbles", description]
        activity.eligibleForSearch = true
        activity.eligibleForPublicIndexing = true
        
        let attributes = CSSearchableItemAttributeSet(itemContentType: "url")
        attributes.title = description
        activity.contentAttributeSet = attributes
        return activity
    }
}