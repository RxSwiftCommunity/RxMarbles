//
//  OperatorImplementation.swift
//  RxMarbles
//
//  Created by Yury Korolev on 1/22/16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import Foundation
import RxSwift

struct InitialValues {
    let line1: [RecordedType]
    let line2: [RecordedType]
}

extension Operator {
    var initial: InitialValues {
        switch self {
        case Amb:
            return InitialValues(
                line1: [
                    next(100, "10", Color.nextRandom, .Circle),
                    next(200, "20", Color.nextRandom, .Circle),
                    next(300, "30", Color.nextRandom, .Circle),
                    next(400, "40", Color.nextRandom, .Circle),
                    next(500, "50", Color.nextRandom, .Circle),
                    next(600, "60", Color.nextRandom, .Circle),
                    next(700, "70", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: [
                    next(150, "1", Color.nextRandom, .Star),
                    next(250, "2", Color.nextRandom, .Star),
                    next(350, "3", Color.nextRandom, .Star),
                    next(450, "4", Color.nextRandom, .Star),
                    next(550, "5", Color.nextRandom, .Star),
                    next(650, "6", Color.nextRandom, .Star),
                    next(750, "7", Color.nextRandom, .Star),
                    completed(900)
                ]
            )
        case CombineLatest:
            return InitialValues(
                line1: [
                    next( 80, "1", Color.nextRandom, .Circle),
                    next(300, "2", Color.nextRandom, .Circle),
                    next(500, "3", Color.nextRandom, .Circle),
                    next(650, "4", Color.nextRandom, .Circle),
                    next(800, "5", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: [
                    next(200, "a", Color.nextRandom, .Rect),
                    next(400, "b", Color.nextRandom, .Rect),
                    next(550, "c", Color.nextRandom, .Rect),
                    next(750, "d", Color.nextRandom, .Rect),
                    completed(900)
                ]
            )
        case Delay:
            return InitialValues(
                line1: [
                    next(100, "", Color.nextRandom, .Circle),
                    next(200, "", Color.nextRandom, .Circle),
                    next(300, "", Color.nextRandom, .Circle),
                    next(400, "", Color.nextRandom, .Circle),
                    next(500, "", Color.nextRandom, .Circle),
                    completed(700)
                ],
                line2: []
            )
        case Debounce:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(400, "2", Color.nextRandom, .Circle),
                    next(450, "3", Color.nextRandom, .Circle),
                    next(500, "4", Color.nextRandom, .Circle),
                    next(550, "5", Color.nextRandom, .Circle),
                    next(700, "6", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: []
            )
        case DistinctUntilChanged:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(200, "2", Color.nextRandom, .Circle),
                    next(300, "2", Color.nextRandom, .Circle),
                    next(500, "1", Color.nextRandom, .Circle),
                    next(600, "3", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: []
            )
        case ElementAt:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(200, "2", Color.nextRandom, .Circle),
                    next(300, "3", Color.nextRandom, .Circle),
                    next(400, "4", Color.nextRandom, .Circle),
                    next(500, "5", Color.nextRandom, .Circle),
                    next(600, "6", Color.nextRandom, .Circle),
                    next(700, "7", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: []
            )
        case Empty:
            return InitialValues(
                line1: [],
                line2: []
            )
        case IgnoreElements:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(200, "2", Color.nextRandom, .Rect),
                    next(300, "3", Color.nextRandom, .Triangle),
                    next(400, "4", Color.nextRandom, .Star),
                    next(500, "5", Color.nextRandom, .Circle),
                    next(600, "6", Color.nextRandom, .Rect),
                    next(700, "7", Color.nextRandom, .Triangle),
                    next(800, "8", Color.nextRandom, .Star),
                    completed(900)
                ],
                line2: []
            )
        case Retry:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(200, "2", Color.nextRandom, .Circle),
                    next(300, "3", Color.nextRandom, .Circle),
                    error(400),
                    completed(900)
                ],
                line2: []
            )
        case Map:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(200, "2", Color.nextRandom, .Circle),
                    next(400, "3", Color.nextRandom, .Circle),
                    next(500, "4", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: []
            )
        case Never:
            return InitialValues(
                line1: [],
                line2: []
            )
        case Filter:
            return InitialValues(
                line1: [
                    next(100, "2", Color.nextRandom, .Circle),
                    next(200, "30", Color.nextRandom, .Circle),
                    next(300, "22", Color.nextRandom, .Circle),
                    next(400, "5", Color.nextRandom, .Circle),
                    next(500, "60", Color.nextRandom, .Circle),
                    next(600, "1", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: []
            )
        case Just:
            return InitialValues(
                line1: [],
                line2: []
            )
        case Scan:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(200, "2", Color.nextRandom, .Circle),
                    next(300, "3", Color.nextRandom, .Circle),
                    next(400, "4", Color.nextRandom, .Circle),
                    next(600, "5", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: []
            )
        case Skip:
            return InitialValues(
                line1: [
                    next(300, "1", Color.nextRandom, .Circle),
                    next(400, "2", Color.nextRandom, .Circle),
                    next(600, "3", Color.nextRandom, .Circle),
                    next(700, "4", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: []
            )
        case Throw:
            return InitialValues(
                line1: [],
                line2: []
            )
        case Zip:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(300, "2", Color.nextRandom, .Circle),
                    next(700, "3", Color.nextRandom, .Circle),
                    next(750, "4", Color.nextRandom, .Circle),
                    next(800, "5", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: [
                    next(200, "a", Color.nextRandom, .Rect),
                    next(350, "b", Color.nextRandom, .Rect),
                    next(600, "c", Color.nextRandom, .Rect),
                    next(650, "d", Color.nextRandom, .Rect),
                    completed(900)
                ]
            )
        default:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(200, "2", Color.nextRandom, .Circle),
                    next(300, "3", Color.nextRandom, .Circle),
                    next(400, "4", Color.nextRandom, .Circle),
                    next(500, "5", Color.nextRandom, .Circle),
                    next(600, "6", Color.nextRandom, .Circle),
                    next(700, "7", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: [
                    next(100, "1", Color.nextRandom, .Rect),
                    next(200, "2", Color.nextRandom, .Rect),
                    next(300, "3", Color.nextRandom, .Rect),
                    next(400, "4", Color.nextRandom, .Rect),
                    next(500, "5", Color.nextRandom, .Rect),
                    next(600, "6", Color.nextRandom, .Rect),
                    next(700, "7", Color.nextRandom, .Rect),
                    completed(900)
                ]
            )
        }
    }
}

extension Operator {
    var code:[(pre: String, post: String)] {
        switch self {
        case Amb: return [(pre: "", post: ""), (pre:".amb(", post: ")")]
        case CombineLatest:
            return [
                (pre: "Observable.combineLatest(", post: ""),
                (pre: ",", post: ") { $0 + $1 }")
            ]
        case Concat:
            return [
                (pre: "[", post: ""),
                (pre: ",", post: "].concat()"),
            ]
        case Debounce:
            return [
                (pre: "", post: ".debounce(100, scheduler: scheduler)"),
            ]
        case Delay:
            return [
                (pre: "", post: ".delaySubscription(150, scheduler: scheduler)"),
            ]
        case DistinctUntilChanged:
            return [
                (pre: "", post: ".distinctUntilChanged()")
            ]
        case ElementAt: return [(pre: "", post: ".elementAt(2)")]
        case FlatMap:   return [(pre: "", post: ""), (pre: ".flatMap({", post: "})")]
        case Filter:    return [(pre: "", post: ".filter { $0 > 10 } ")]
        case IgnoreElements: return [(pre: "", post: ".ignoreElements()")]
        case Map:
            return [
                (pre: "", post: ".map( { $0 * 10 } )"),
            ]
        case Retry:
            return [
                (pre: "", post: ".retry(2)"),
            ]
        case Scan:
            return [
                (pre: "", post: ".scan(0) { $0 + $1 } "),
            ]
        case Skip:      return [(pre: "", post: ".skip(2)")]
        case Zip:        return [(pre: "Observable.zip(", post: ","), (pre: "", post: ") { $0 + $1 }")]
        default: return []
        }
    }
}

extension Operator {
    func map(o: (first: TestableObservable<ColoredType>?, second: TestableObservable<ColoredType>?), scheduler: TestScheduler) -> Observable<ColoredType> {
        switch self {
        case Amb:                  return o.first!.amb(o.second!)
        case Buffer:               return o.first!
            .buffer(timeSpan: 150, count: 3, scheduler: scheduler)
            .map({ events in
                let values = events.map({$0.value }).joinWithSeparator(", ")
                return ColoredType(value: "[\(values)]", color: Color.nextGreen, shape: .Triangle)
            })
        case CatchError:           return o.first!.catchError({ error in
            return Observable.of(ColoredType(value: "1", color: Color.nextBlue, shape: .Circle))
        })
        case CombineLatest:        return Observable.combineLatest(o.first!, o.second!) {
            a, b in
            return ColoredType(value: a.value + b.value, color: a.color, shape: a.shape)
        }
        case Concat:               return [o.first!, o.second!].concat()
        case Debounce:             return o.first!.debounce(100, scheduler: scheduler)
        case Delay:                return o.first!.delaySubscription(150, scheduler: scheduler)
        case DistinctUntilChanged: return o.first!.distinctUntilChanged()
        case ElementAt:            return o.first!.elementAt(2)
        case Empty:                return Observable<ColoredType>.empty()
        case Filter:               return o.first!.filter {
            guard let a = Int($0.value) else { throw Error.CantParseStringToInt }
            return a > 10
        }
        case FlatMap:              return o.first!.flatMap({ event in return o.second! })
        case FlatMapFirst:         return o.first!.flatMapFirst({ event in return o.second! })
        case FlatMapLatest:        return o.first!.flatMapLatest({ event in return o.second! })
        case IgnoreElements:       return o.first!.ignoreElements()
        case Just:                 return Observable.just(ColoredType(value: "", color: Color.nextRandom, shape: .Circle))
        case Map:                  return o.first!.map({ h in
            guard let a = Int(h.value) else { throw Error.CantParseStringToInt }
            return ColoredType(value: String(a * 10), color: h.color, shape: h.shape)
        })
        case MapWithIndex:         return o.first!.mapWithIndex({ (element, index) in
            if index == 1 {
                guard let a = Int(element.value) else { throw Error.CantParseStringToInt }
                return ColoredType(value: String(a * 10), color: element.color, shape: element.shape)
            } else {
                return element
            }
        })
        case Merge:                return Observable.of(o.first!, o.second!).merge()
        case Never:                return Observable.never()
        case Reduce:
            return o.first!.reduce(ColoredType(value: "0", color: .redColor(), shape: o.first!.recordedEvents.first?.value.element?.shape != nil ? (o.first!.recordedEvents.first?.value.element?.shape)! : .None), accumulator: { acc, e in
                var res = acc
                guard let a = Int(e.value),
                    let b = Int(res.value) else { throw Error.CantParseStringToInt }
                res.value = String(a + b)
                res.color = e.color
                res.shape = e.shape
                return res
        })
        case Retry:                return o.first!.retry(2)
        case Sample:               return o.first!.sample(o.second!)
        case Scan:                 return o.first!.scan(ColoredType(value: String(0), color: .redColor(), shape: o.first!.recordedEvents.first?.value.element?.shape != nil ? (o.first!.recordedEvents.first?.value.element?.shape)! : .None), accumulator: { acc, e in
            var res = acc
            guard let a = Int(e.value),
                  let b = Int(res.value) else { throw Error.CantParseStringToInt }
            res.value = String(a + b)
            res.color = e.color
            res.shape = e.shape
            return res
        })
        case Skip:                 return o.first!.skip(2)
        case StartWith:            return o.first!.startWith(ColoredType(value: "2", color: .redColor(), shape: .Circle))
        case Take:                 return o.first!.take(2)
        case TakeLast:             return o.first!.takeLast(2)
        case Throw:                return Observable.error(Error.CantParseStringToInt)
        case Zip:                  return Observable.zip(o.first!, o.second!) {
            a, b in
                return ColoredType(value: a.value + b.value, color: a.color, shape: b.shape)
            }
        }
    }
}

extension Operator {
    var multiTimelines: Bool {
        switch self {
        case Amb:                  return true
        case Buffer:               return false
        case CatchError:           return false
        case CombineLatest:        return true
        case Concat:               return true
        case Debounce:             return false
        case Delay:                return false
        case DistinctUntilChanged: return false
        case ElementAt:            return false
        case Empty:                return false
        case Filter:               return false
        case FlatMap:              return true
        case FlatMapFirst:         return true
        case FlatMapLatest:        return true
        case IgnoreElements:       return false
        case Just:                 return false
        case Map:                  return false
        case MapWithIndex:         return false
        case Merge:                return true
        case Never:                return false
        case Reduce:               return false
        case Retry:                return false
        case Sample:               return true
        case Scan:                 return false
        case Skip:                 return false
        case StartWith:            return false
        case Take:                 return false
        case TakeLast:             return false
        case Throw:                return false
        case Zip:                  return true
        }
    }
    
    var withoutTimelines: Bool {
        return [Empty, Never, Throw, Just].contains(self)
    }
}