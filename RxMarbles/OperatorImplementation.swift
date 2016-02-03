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
        case CatchError:
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
        case Concat:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(300, "2", Color.nextRandom, .Circle),
                    next(600, "3", Color.nextRandom, .Circle),
                    completed(650)
                ],
                line2: [
                    next(100, "2", Color.nextRandom, .Rect),
                    next(200, "2", Color.nextRandom, .Rect),
                    completed(300)
                ]
            )
        case DelaySubscription:
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
        case FlatMap:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(400, "2", Color.nextRandom, .Circle),
                    next(500, "3", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(200, "2", Color.nextRandom, .Circle),
                    completed(300)
                ]
            )
        case FlatMapFirst:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(400, "2", Color.nextRandom, .Circle),
                    next(500, "3", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(200, "2", Color.nextRandom, .Circle),
                    completed(300)
                ]
            )
        case FlatMapLatest:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(400, "2", Color.nextRandom, .Circle),
                    next(500, "3", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(200, "2", Color.nextRandom, .Circle),
                    completed(300)
                ]
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
        case MapWithIndex:
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
        case Merge:
            return InitialValues(
                line1: [
                    next(150, "20", Color.nextRandom, .Circle),
                    next(300, "40", Color.nextRandom, .Circle),
                    next(450, "60", Color.nextRandom, .Circle),
                    next(600, "80", Color.nextRandom, .Circle),
                    next(750, "100", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: [
                    next(550, "1", Color.nextRandom, .Circle),
                    next(650, "2", Color.nextRandom, .Circle),
                    completed(900)
                ]
            )
        case Never:
            return InitialValues(
                line1: [],
                line2: []
            )
        case Reduce:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(200, "2", Color.nextRandom, .Circle),
                    next(300, "3", Color.nextRandom, .Circle),
                    next(400, "4", Color.nextRandom, .Circle),
                    next(700, "5", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: []
            )
        
        case Just:
            return InitialValues(
                line1: [],
                line2: []
            )
        case Sample:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(200, "2", Color.nextRandom, .Circle),
                    next(400, "3", Color.nextRandom, .Circle),
                    next(550, "4", Color.nextRandom, .Circle),
                    next(700, "5", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: [
                    next( 50, "a", Color.nextRandom, .Rect),
                    next(250, "b", Color.nextRandom, .Rect),
                    next(350, "c", Color.nextRandom, .Rect),
                    next(600, "d", Color.nextRandom, .Rect),
                    completed(800)
                ]
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
        case StartWith:
            return InitialValues(
                line1: [
                    next(300, "2", Color.nextRandom, .Circle),
                    next(400, "3", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: []
            )
        case Take:
            return InitialValues(
                line1: [
                    next(300, "1", Color.nextRandom, .Circle),
                    next(400, "2", Color.nextRandom, .Circle),
                    next(700, "3", Color.nextRandom, .Circle),
                    next(800, "4", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: []
            )
        case TakeLast:
            return InitialValues(
                line1: [
                    next(300, "1", Color.nextRandom, .Circle),
                    next(400, "2", Color.nextRandom, .Circle),
                    next(700, "3", Color.nextRandom, .Circle),
                    next(800, "4", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: []
            )
        case Throw:
            return InitialValues(
                line1: [],
                line2: []
            )
        case Window:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(200, "2", Color.nextRandom, .Circle),
                    next(300, "3", Color.nextRandom, .Circle),
                    next(400, "4", Color.nextRandom, .Circle),
                    next(500, "5", Color.nextRandom, .Circle),
                    next(600, "6", Color.nextRandom, .Circle),
                    completed(900)
                ],
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
    func map(scheduler: TestScheduler, aO: TestableObservable<ColoredType>?, bO: TestableObservable<ColoredType>?) -> Observable<ColoredType> {
        switch self {
        case Amb:
            return aO!.amb(bO!)
        case Buffer:
            return aO!
                .buffer(timeSpan: 150, count: 3, scheduler: scheduler)
                .map {
                    let values = $0.map {$0.value } .joinWithSeparator(", ")
                    return ColoredType(value: "[\(values)]", color: Color.nextGreen, shape: .Triangle)
                }
        case CatchError:
            return aO!.catchError { error in
                return Observable.of(ColoredType(value: "1", color: Color.nextBlue, shape: .Circle))
            }
        case CombineLatest:
            return Observable.combineLatest(aO!, bO!) {
                return ColoredType(value: $0.value + $1.value, color: $0.color, shape: $1.shape)
            }
        case Concat:
            return [aO!, bO!].concat()
        case Debounce:
            return aO!.debounce(100, scheduler: scheduler)
        case DelaySubscription:
            return aO!.delaySubscription(150, scheduler: scheduler)
        case DistinctUntilChanged:
            return aO!.distinctUntilChanged()
        case ElementAt:
            return aO!.elementAt(2)
        case Empty:
            return Observable.empty()
        case Filter:
            return aO!.filter {
                guard let a = Int($0.value) else { throw Error.CantParseStringToInt }
                return a > 10
            }
        case FlatMap:
            return aO!.flatMap { _ in bO! }
        case FlatMapFirst:
            return aO!.flatMapFirst { _ in bO! }
        case FlatMapLatest:
            return aO!.flatMapLatest { _ in bO! }
        case IgnoreElements:
            return aO!.ignoreElements()
        case Just:
            return Observable.just(ColoredType(value: "", color: Color.nextRandom, shape: .Circle))
        case Map:
            return aO!.map { h in
                guard let a = Int(h.value) else { throw Error.CantParseStringToInt }
                return ColoredType(value: String(a * 10), color: h.color, shape: h.shape)
            }
        case MapWithIndex:
            return aO!.mapWithIndex { element, index in
                if index == 1 {
                    guard let a = Int(element.value) else { throw Error.CantParseStringToInt }
                    return ColoredType(value: String(a * 10), color: element.color, shape: element.shape)
                } else {
                    return element
                }
            }
        case Merge:
            return Observable.of(aO!, bO!).merge()
        case Never:
            return Observable.never()
        case Reduce:
            return aO!.reduce(ColoredType(value: "0", color: Color.nextGreen, shape: .Circle)) {
                guard let a = Int($0.value), let b = Int($1.value) else { throw Error.CantParseStringToInt }
                return ColoredType(value: String(a + b), color: $1.color, shape: $1.shape)
            }
        case Retry:
            return aO!.retry(2)
        case Sample:
            return aO!.sample(bO!)
        case Scan:
            return aO!.scan(ColoredType(value: "0", color: Color.nextGreen, shape: .Star)) { acc, e in
                guard let a = Int(e.value), let b = Int(acc.value) else { throw Error.CantParseStringToInt }
                return ColoredType(value: String(a + b), color: e.color, shape: e.shape)
            }
        case Skip:
            return aO!.skip(2)
        case StartWith:
            return aO!.startWith(ColoredType(value: "1", color: Color.nextGreen, shape: .Circle))
        case Take:
            return aO!.take(2)
        case TakeLast:
            return aO!.takeLast(1)
        case Throw:
            return Observable.error(Error.CantParseStringToInt)
        case Window:
            let window = aO?.window(timeSpan: 300, count: 2, scheduler: scheduler)
            return window!.merge()
        case Zip:
            return Observable.zip(aO!, bO!) {
                return ColoredType(value: $0.value + $1.value, color: $0.color, shape: $1.shape)
            }
        }
    }
}

extension Operator {
    var multiTimelines: Bool {
        switch self {
        case
        .Amb,
        .CombineLatest,
        .Concat,
        .FlatMap,
        .FlatMapFirst,
        .FlatMapLatest,
        .Merge,
        .Sample,
        .Zip:
            return true
            
        case
        .Buffer,
        .CatchError,
        .Debounce,
        .DelaySubscription,
        .DistinctUntilChanged,
        .ElementAt,
        .Empty,
        .Filter,
        .IgnoreElements,
        .Just,
        .Map,
        .MapWithIndex,
        .Never,
        .Reduce,
        .Retry,
        .Scan,
        .Skip,
        .StartWith,
        .Take,
        .TakeLast,
        .Throw,
        .Window:
            return false
        }
    }
    
    var withoutTimelines: Bool {
        switch self {
        case .Empty, .Never, .Throw, .Just:
            return true
        default:
            return false
        }
    }
}