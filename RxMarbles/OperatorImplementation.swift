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
        case FlatMap, FlatMapFirst, FlatMapLatest:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .Circle),
                    next(400, "2", Color.nextRandom, .Circle),
                    next(500, "3", Color.nextRandom, .Circle),
                    completed(900)
                ],
                line2: [
                    next(100, "1", Color.nextLightGray, .Rect),
                    next(200, "2", Color.nextLightGray, .Rect),
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
        case CatchErrorJustReturn:
            return aO!.catchErrorJustReturn(ColoredType(value: "1", color: Color.nextBlue, shape: .Circle))
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
            return aO!.flatMap { e in
                bO!.map { event in
                    event.color == Color.nextLightGray ? ColoredType(value: event.value, color: e.color, shape: event.shape) : event
                }
            }
        case FlatMapFirst:
            return aO!.flatMapFirst { e in
                bO!.map { event in
                    event.color == Color.nextLightGray ? ColoredType(value: event.value, color: e.color, shape: event.shape) : event
                }
            }
        case FlatMapLatest:
            return aO!.flatMapLatest { e in
                bO!.map { event in
                    event.color == Color.nextLightGray ? ColoredType(value: event.value, color: e.color, shape: event.shape) : event
                }
            }
//        case FlatMapWithIndex:
//            return aO!.flatMapWithIndex { e, i  in
//                
//            }
        case IgnoreElements:
            return aO!.ignoreElements()
        case Interval:
            return Observable<Int64>.interval(100, scheduler: scheduler).map { t in ColoredType(value: String(t), color: Color.nextRandom, shape: .Circle) }
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
        case Of:
            return Observable.of(ColoredType(value: "1", color: Color.nextRandom, shape: .Star))
        case Reduce:
            return aO!.reduce(ColoredType(value: "0", color: Color.nextGreen, shape: .Circle)) {
                guard let a = Int($0.value), let b = Int($1.value) else { throw Error.CantParseStringToInt }
                return ColoredType(value: String(a + b), color: $1.color, shape: $1.shape)
            }
        case RepeatElement:
            return Observable<Int64>.interval(150, scheduler: scheduler).map { _ in ColoredType(value: "1", color: Color.nextGreen, shape: .Star)}
        case Retry:
            return aO!.retry(2)
        case Sample:
            return aO!.sample(bO!)
        case Scan:
            return aO!.scan(ColoredType(value: "0", color: Color.nextGreen, shape: .Star)) { acc, e in
                guard let a = Int(e.value), let b = Int(acc.value) else { throw Error.CantParseStringToInt }
                return ColoredType(value: String(a + b), color: e.color, shape: e.shape)
            }
        case Single:
            return aO!.single()
        case Skip:
            return aO!.skip(2)
        case SkipUntil:
            return aO!.skipUntil(bO!)
        case SkipWhile:
            return aO!.skipWhile { e in Int(e.value) < 4 }
        case SkipWhileWithIndex:
            return aO!.skipWhileWithIndex { e, i in i < 4 }
        case StartWith:
            return aO!.startWith(ColoredType(value: "1", color: Color.nextGreen, shape: .Circle))
        case SwitchLatest:
            return Observable.of(aO!, bO!).switchLatest()
        case Take:
            return aO!.take(2)
        case TakeLast:
            return aO!.takeLast(2)
        case TakeUntil:
            return aO!.takeUntil(bO!)
        case TakeWhile:
            return aO!.takeWhile { e in Int(e.value) < 4 }
        case TakeWhileWithIndex:
            return aO!.takeWhileWithIndex { e, i in i < 4 }
        case Throttle:
            return aO!.throttle(500, scheduler: scheduler)
        case Throw:
            return Observable.error(Error.CantParseStringToInt)
        case Timeout:
            return aO!.timeout(200, scheduler: scheduler)
        case Timer:
            return Observable<Int64>.timer(500, scheduler: scheduler).map { _ in ColoredType(value: "1", color: Color.nextRandom, shape: .Circle) }
        case ToArray:
            return aO!
                .toArray()
                .map {
                let values = $0.map {$0.value } .joinWithSeparator(", ")
                return ColoredType(value: "[\(values)]", color: Color.nextGreen, shape: .Rect)
            }
        case WithLatestFrom:
            return aO!.withLatestFrom(bO!)
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
        .SkipUntil,
        .SwitchLatest,
        .TakeUntil,
        .WithLatestFrom,
        .Zip:
            return true
            
        case
        .Buffer,
        .CatchError,
        .CatchErrorJustReturn,
        .Debounce,
        .DelaySubscription,
        .DistinctUntilChanged,
        .ElementAt,
        .Empty,
        .Filter,
        .IgnoreElements,
        .Interval,
        .Just,
        .Map,
        .MapWithIndex,
        .Never,
        .Of,
        .Reduce,
        .RepeatElement,
        .Retry,
        .Scan,
        .Single,
        .Skip,
        .SkipWhile,
        .SkipWhileWithIndex,
        .StartWith,
        .Take,
        .TakeLast,
        .TakeWhile,
        .TakeWhileWithIndex,
        .Throttle,
        .Throw,
        .Timeout,
        .Timer,
        .ToArray:
            return false
        }
    }
    
    var withoutTimelines: Bool {
        switch self {
        case .Empty, .Interval, .Just, .Never, .Of, .RepeatElement, .Throw, .Timer:
            return true
        default:
            return false
        }
    }
}

extension Operator {
    var urlString: String {
        switch self {
        case CatchError, CatchErrorJustReturn:
            return "catch.html"
        case DelaySubscription:
            return "delay.html"
        case DistinctUntilChanged:
            return "distinct.html"
        case Empty, Never, Throw:
            return "empty-never-throw.html"
        case FlatMap, FlatMapFirst, FlatMapLatest:
            return "flatmap.html"
        case IgnoreElements:
            return "ignoreelements.html"
        case Map, MapWithIndex:
            return "map.html"
        case Of:
            return "from.html"
        case RepeatElement:
            return "repeat.html"
        case Single:
            return "first.html"
        case SkipWhileWithIndex:
            return "skipwhile.html"
        case SwitchLatest:
            return "switch.html"
        case TakeWhileWithIndex:
            return "takewhile.html"
        case Throttle:
            return "debounce.html"
        case ToArray:
            return "to.html"
        case WithLatestFrom:
            return "combinelatest.html"
        default:
            return "\(rawValue.lowercaseString).html"
        }
    }
    
    var url: NSURL {
        let reactivex = "http://reactivex.io/documentation/operators/"
        return NSURL(string: reactivex + urlString)!
    }
}

extension Operator {
    var text: String {
        switch self {
        case Amb:
            return "Given two or more source Observables, emit all of the items from only the first of these Obserbables to emit an item or notification."
        case Buffer:
            return "Periodically gather items emitted by an Observable into bundles and emit these bundles rather than emitting the items one at a time."
        case CatchError, CatchErrorJustReturn:
            return "Recover from an onError notification by continuing the sequence without error."
        case CombineLatest, WithLatestFrom:
            return "When an item is emitted by either of two Observables, combine the latest item emitted by each Observable via a specified function and emit items based on the results of this function."
        case Concat:
            return "Emit the emissions from two or more Observables without interleaving them."
        case Debounce, Throttle:
            return "Only emit an item from an Observable if a particular timespan has passed without it emitting another item."
        case DelaySubscription:
            return "Shift the emissions from an Observable forward in time by a particular amount."
        case DistinctUntilChanged:
            return "Suppress duplicate items emitted by an Observable."
        case ElementAt:
            return "Emit only item n emitted by an Observable."
        case Empty:
            return "Create an Observable that emits no items but terminates normally."
        case Filter:
            return "Emit only those items from an Observable that pass a predicate test."
        case FlatMap:
            return "Transform the items emitted by an Observable into Observables, then flatten the emissions from those into a single Observable."
        case FlatMapFirst:
            return "Transform the items emitted by an Observable into Observables, then flatten the emissions from those into a single Observable."
        case FlatMapLatest:
            return "Transform the items emitted by an Observable into Observables, then flatten the emissions from those into a single Observable."
        case IgnoreElements:
            return "Do not emit any items from an Observable but mirror its termination notification."
        case Interval:
            return "Create an Observable that emits a sequence of integers spaced by a given time interval."
        case Just:
            return "Create an Observable that emits a particular item."
        case Map:
            return "Transform the items emitted by an Observable by applying a function to each item."
        case MapWithIndex:
            return "Transform the items emitted by an Observable by applying a function to each item."
        case Merge:
            return "Combine multiple Observables into one by merging their emissions."
        case Never:
            return "Create an Observable that emits no items and does not terminate."
        case Of:
            return "Convert various other objects and data types into Observables."
        case Reduce:
            return "Apply a function to each item emitted by an Observable, sequentially, and emit the final value."
        case RepeatElement:
            return "Create an Observable that emits a particular item multiple times."
        case Retry:
            return "If a source Observable emits an error, resubscribe to it in the hopes that it will complete without error."
        case Sample:
            return "Emit the most recent items emitted by an Observable within periodic time intervals."
        case Scan:
            return "Apply a function to each item emitted by an Observable, sequentially, and emit each successive value."
        case Single:
            return "Emit only the first item (or the first item that meets some condition) emitted by an Observable."
        case Skip:
            return "Suppress the first n items emitted by an Observable."
        case SkipUntil:
            return "Discard items emitted by an Observable until a second Observable emits an item."
        case SkipWhile, SkipWhileWithIndex:
            return "Discard items emitted by an Observable until a specified condition becomes false."
        case StartWith:
            return "Emit a specified sequence of items before beginning to emit the items from the source Observable."
        case SwitchLatest:
            return "Convert an Observable that emits Observables into a single Observable that emits the items emitted by the most-recently-emitted of those Observables."
        case Take:
            return "Emit only the first n items emitted by an Observable."
        case TakeLast:
            return "Emit only the final n items emitted by an Observable."
        case TakeUntil:
            return "Discard any items emitted by an Observable after a second Observable emits an item or terminates."
        case TakeWhile, TakeWhileWithIndex:
            return "Mirror items emitted by an Observable until a specified condition becomes false."
        case Throw:
            return "Create an Observable that emits no items and terminates with an error."
        case Timeout:
            return "Mirror the source Observable, but issue an error notification if a particular period of time elapses without any emitted items."
        case Timer:
            return "Create an Observable that emits a particular item after a given delay."
        case ToArray:
            return "Convert an Observable into another object or data structure."
        case Zip:
            return "Combine the emissions of multiple Observables together via a specified function and emit single items for each combination based on the results of this function."
        }
    }
    
    var linkText: NSMutableAttributedString {
        let res = NSMutableAttributedString(string: text)
        let link = NSMutableAttributedString(string: "Read\u{a0}more...", attributes: [NSLinkAttributeName: url])
        res.appendAttributedString(NSAttributedString(string: " "))
        res.appendAttributedString(link)
        res.addAttribute(NSFontAttributeName, value: UIFont(name: "Menlo-Regular", size: 16)!, range: NSMakeRange(0, res.length))
        return res
    }
}
