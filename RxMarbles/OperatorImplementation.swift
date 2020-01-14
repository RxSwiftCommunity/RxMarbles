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
    
    init(line1: [RecordedType] = [], line2: [RecordedType] = []) {
        self.line1 = line1
        self.line2 = line2
    }
}

extension Operator {
    var initial: InitialValues {
        switch self {
        case .amb:
            return InitialValues(
                line1: [
                    next(100, "10", Color.nextRandom, .circle),
                    next(200, "20", Color.nextRandom, .circle),
                    next(300, "30", Color.nextRandom, .circle),
                    next(400, "40", Color.nextRandom, .circle),
                    next(500, "50", Color.nextRandom, .circle),
                    next(600, "60", Color.nextRandom, .circle),
                    next(700, "70", Color.nextRandom, .circle),
                    completed(900)
                ],
                line2: [
                    next(150, "1", Color.nextRandom, .star),
                    next(250, "2", Color.nextRandom, .star),
                    next(350, "3", Color.nextRandom, .star),
                    next(450, "4", Color.nextRandom, .star),
                    next(550, "5", Color.nextRandom, .star),
                    next(650, "6", Color.nextRandom, .star),
                    next(750, "7", Color.nextRandom, .star),
                    completed(900)
                ]
            )
        case .catchError:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(200, "2", Color.nextRandom, .circle),
                    next(300, "3", Color.nextRandom, .circle),
                    error(400),
                    completed(900)
                ]
            )
        case .catchErrorJustReturn:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(200, "2", Color.nextRandom, .circle),
                    next(300, "3", Color.nextRandom, .circle),
                    next(400, "4", Color.nextRandom, .circle),
                    error(400),
                    completed(900)
                ]
            )
        case .combineLatest:
            return InitialValues(
                line1: [
                    next( 80, "1", Color.nextRandom, .circle),
                    next(300, "2", Color.nextRandom, .circle),
                    next(500, "3", Color.nextRandom, .circle),
                    next(650, "4", Color.nextRandom, .circle),
                    next(800, "5", Color.nextRandom, .circle),
                    completed(900)
                ],
                line2: [
                    next(200, "a", Color.nextRandom, .rect),
                    next(400, "b", Color.nextRandom, .rect),
                    next(550, "c", Color.nextRandom, .rect),
                    next(750, "d", Color.nextRandom, .rect),
                    completed(900)
                ]
            )
        case .concat:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(300, "2", Color.nextRandom, .circle),
                    next(600, "3", Color.nextRandom, .circle),
                    completed(650)
                ],
                line2: [
                    next(100, "2", Color.nextRandom, .rect),
                    next(200, "2", Color.nextRandom, .rect),
                    completed(300)
                ]
            )
        case .delaySubscription:
            return InitialValues(
                line1: [
                    next(100, "", Color.nextRandom, .circle),
                    next(200, "", Color.nextRandom, .circle),
                    next(300, "", Color.nextRandom, .circle),
                    next(400, "", Color.nextRandom, .circle),
                    next(500, "", Color.nextRandom, .circle),
                    completed(700)
                ]
            )
        case .debounce:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(400, "2", Color.nextRandom, .circle),
                    next(450, "3", Color.nextRandom, .circle),
                    next(500, "4", Color.nextRandom, .circle),
                    next(700, "5", Color.nextRandom, .circle),
                    completed(900)
                ]
            )
        case .throttle:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(310, "2", Color.nextRandom, .circle),
                    next(340, "3", Color.nextRandom, .circle),
                    next(370, "4", Color.nextRandom, .circle),
                    next(400, "5", Color.nextRandom, .circle),
                    next(700, "6", Color.nextRandom, .circle),
                    completed(900)
                ]
            )
        case .distinctUntilChanged:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(200, "2", Color.nextRandom, .circle),
                    next(300, "2", Color.nextRandom, .circle),
                    next(500, "1", Color.nextRandom, .circle),
                    next(600, "3", Color.nextRandom, .circle),
                    completed(900)
                ]
            )
        case .elementAt:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(200, "2", Color.nextRandom, .circle),
                    next(300, "3", Color.nextRandom, .circle),
                    next(400, "4", Color.nextRandom, .circle),
                    next(500, "5", Color.nextRandom, .circle),
                    next(600, "6", Color.nextRandom, .circle),
                    next(700, "7", Color.nextRandom, .circle),
                    completed(900)
                ]
            )
        case .empty:
            return InitialValues()
        case .filter:
            return InitialValues(
                line1: [
                    next(100, "2", Color.nextRandom, .circle),
                    next(200, "30", Color.nextRandom, .circle),
                    next(300, "22", Color.nextRandom, .circle),
                    next(400, "5", Color.nextRandom, .circle),
                    next(500, "60", Color.nextRandom, .circle),
                    next(600, "1", Color.nextRandom, .circle),
                    completed(900)
                ]
            )
        case .flatMap, .flatMapFirst, .flatMapLatest:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(400, "2", Color.nextRandom, .circle),
                    next(500, "3", Color.nextRandom, .circle),
                    completed(900)
                ],
                line2: [
                    next(100, "1", Color.nextLightGray, .rect),
                    next(200, "2", Color.nextLightGray, .rect),
                    completed(300)
                ]
            )
        case .ignoreElements:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(200, "2", Color.nextRandom, .rect),
                    next(300, "3", Color.nextRandom, .triangle),
                    next(400, "4", Color.nextRandom, .star),
                    next(500, "5", Color.nextRandom, .circle),
                    next(600, "6", Color.nextRandom, .rect),
                    next(700, "7", Color.nextRandom, .triangle),
                    next(800, "8", Color.nextRandom, .star),
                    completed(900)
                ]
            )
        case .retry:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(200, "2", Color.nextRandom, .circle),
                    next(300, "3", Color.nextRandom, .circle),
                    error(400),
                    completed(900)
                ]
            )
        case .map:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(200, "2", Color.nextRandom, .circle),
                    next(400, "3", Color.nextRandom, .circle),
                    next(500, "4", Color.nextRandom, .circle),
                    completed(900)
                ]
            )
        case .mapWithIndex:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(200, "2", Color.nextRandom, .circle),
                    next(400, "3", Color.nextRandom, .circle),
                    next(500, "4", Color.nextRandom, .circle),
                    completed(900)
                ]
            )
        case .merge:
            return InitialValues(
                line1: [
                    next(150, "20", Color.nextRandom, .circle),
                    next(300, "40", Color.nextRandom, .circle),
                    next(450, "60", Color.nextRandom, .circle),
                    next(600, "80", Color.nextRandom, .circle),
                    next(750, "100", Color.nextRandom, .circle),
                    completed(900)
                ],
                line2: [
                    next(550, "1", Color.nextRandom, .circle),
                    next(650, "2", Color.nextRandom, .circle),
                    completed(900)
                ]
            )
        case .never:
            return InitialValues()
        case .reduce:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(200, "2", Color.nextRandom, .circle),
                    next(300, "3", Color.nextRandom, .circle),
                    next(400, "4", Color.nextRandom, .circle),
                    next(700, "5", Color.nextRandom, .circle),
                    completed(900)
                ]
            )
            
        case .just:
            return InitialValues()
        case .sample:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(200, "2", Color.nextRandom, .circle),
                    next(400, "3", Color.nextRandom, .circle),
                    next(550, "4", Color.nextRandom, .circle),
                    next(700, "5", Color.nextRandom, .circle),
                    completed(900)
                ],
                line2: [
                    next( 50, "a", Color.nextRandom, .rect),
                    next(250, "b", Color.nextRandom, .rect),
                    next(350, "c", Color.nextRandom, .rect),
                    next(600, "d", Color.nextRandom, .rect),
                    completed(800)
                ]
            )
        case .scan:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(200, "2", Color.nextRandom, .circle),
                    next(300, "3", Color.nextRandom, .circle),
                    next(400, "4", Color.nextRandom, .circle),
                    next(600, "5", Color.nextRandom, .circle),
                    completed(900)
                ]
            )
        case .skip:
            return InitialValues(
                line1: [
                    next(300, "1", Color.nextRandom, .circle),
                    next(400, "2", Color.nextRandom, .circle),
                    next(600, "3", Color.nextRandom, .circle),
                    next(700, "4", Color.nextRandom, .circle),
                    completed(900)
                ]
            )
        case .skipUntil, .takeUntil:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(200, "2", Color.nextRandom, .circle),
                    next(300, "3", Color.nextRandom, .circle),
                    next(400, "4", Color.nextRandom, .circle),
                    next(500, "5", Color.nextRandom, .circle),
                    next(600, "6", Color.nextRandom, .circle),
                    next(700, "7", Color.nextRandom, .circle),
                    completed(900)
                ],
                line2: [
                    next(350, "a", Color.nextRandom, .rect),
                    next(650, "b", Color.nextRandom, .rect),
                    completed(900)
                ]
            )
        case .startWith:
            return InitialValues(
                line1: [
                    next(300, "2", Color.nextRandom, .circle),
                    next(600, "3", Color.nextRandom, .circle),
                    completed(900)
                ]
            )
        case .switchLatest:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(200, "2", Color.nextRandom, .circle),
                    next(300, "3", Color.nextRandom, .circle),
                    next(400, "4", Color.nextRandom, .circle)
                ],
                line2: [
                    next(150, "1", Color.nextRandom, .rect),
                    next(250, "2", Color.nextRandom, .rect),
                    next(350, "3", Color.nextRandom, .rect),
                    next(450, "4", Color.nextRandom, .rect)
                ])
        case .take:
            return InitialValues(
                line1: [
                    next(300, "1", Color.nextRandom, .circle),
                    next(400, "2", Color.nextRandom, .circle),
                    next(700, "3", Color.nextRandom, .circle),
                    next(800, "4", Color.nextRandom, .circle),
                    completed(900)
                ]
            )
        case .takeLast:
            return InitialValues(
                line1: [
                    next(300, "1", Color.nextRandom, .circle),
                    next(400, "2", Color.nextRandom, .circle),
                    next(700, "3", Color.nextRandom, .circle),
                    next(800, "4", Color.nextRandom, .circle),
                    completed(900)
                ]
            )
        case .throw:
            return InitialValues()
        case .timeout:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(200, "2", Color.nextRandom, .circle),
                    next(300, "3", Color.nextRandom, .circle),
                    next(550, "4", Color.nextRandom, .circle),
                    next(650, "5", Color.nextRandom, .circle),
                    completed(900)
                ]
            )
        case .withLatestFrom:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(200, "2", Color.nextRandom, .circle),
                    next(300, "3", Color.nextRandom, .circle),
                    next(400, "4", Color.nextRandom, .circle)
                ],
                line2: [
                    next(150, "1", Color.nextRandom, .rect),
                    next(250, "2", Color.nextRandom, .rect),
                    next(350, "3", Color.nextRandom, .rect),
                    next(450, "4", Color.nextRandom, .rect)
                ]
            )
        case .zip:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(300, "2", Color.nextRandom, .circle),
                    next(700, "3", Color.nextRandom, .circle),
                    next(750, "4", Color.nextRandom, .circle),
                    next(800, "5", Color.nextRandom, .circle),
                    completed(900)
                ],
                line2: [
                    next(200, "a", Color.nextRandom, .rect),
                    next(350, "b", Color.nextRandom, .rect),
                    next(600, "c", Color.nextRandom, .rect),
                    next(650, "d", Color.nextRandom, .rect),
                    completed(900)
                ]
            )
        default:
            return InitialValues(
                line1: [
                    next(100, "1", Color.nextRandom, .circle),
                    next(200, "2", Color.nextRandom, .circle),
                    next(300, "3", Color.nextRandom, .circle),
                    next(400, "4", Color.nextRandom, .circle),
                    next(500, "5", Color.nextRandom, .circle),
                    next(600, "6", Color.nextRandom, .circle),
                    next(700, "7", Color.nextRandom, .circle),
                    completed(900)
                ],
                line2: [
                    next(100, "1", Color.nextRandom, .rect),
                    next(200, "2", Color.nextRandom, .rect),
                    next(300, "3", Color.nextRandom, .rect),
                    next(400, "4", Color.nextRandom, .rect),
                    next(500, "5", Color.nextRandom, .rect),
                    next(600, "6", Color.nextRandom, .rect),
                    next(700, "7", Color.nextRandom, .rect),
                    completed(900)
                ]
            )
        }
    }
}

extension Operator {
    
    func _map(_ scheduler: TestScheduler, aO: TestableObservable<ColoredType>?, bO: TestableObservable<ColoredType>?) -> Observable<ColoredType> {
        switch self {
        case .amb:
            return aO!.amb(bO!)
        case .buffer:
            return aO!
                .buffer(timeSpan: 150, count: 3, scheduler: scheduler)
                .map {
                    let values = $0.map {$0.value } .joined(separator: ", ")
                    return ColoredType(value: "[\(values)]", color: Color.nextGreen, shape: .triangle)
            }
        case .catchError:
            return aO!.catchError { _ in return .just(ColoredType(value: "1", color: Color.nextBlue, shape: .circle)) }
        case .catchErrorJustReturn:
            return aO!.catchErrorJustReturn(ColoredType(value: "1", color: Color.nextBlue, shape: .circle))
        case .combineLatest:
            return Observable.combineLatest(aO!, bO!) {
                return ColoredType(value: $0.value + $1.value, color: $0.color, shape: $1.shape)
            }
        case .concat:
            return aO!.concat(bO!)
        case .debounce:
            return aO!.debounce(100, scheduler: scheduler)
        case .throttle:
            return aO!.throttle(100, scheduler: scheduler)
        case .delaySubscription:
            return aO!.delaySubscription(150, scheduler: scheduler)
        case .distinctUntilChanged:
            return aO!.distinctUntilChanged()
        case .elementAt:
            return aO!.elementAt(2)
        case .empty:
            return Observable.empty()
        case .filter:
            return aO!.filter {
                guard let a = Int($0.value) else { throw RxError.unknown }
                return a > 10
            }
        case .flatMap:
            return aO!.flatMap { e in
                bO!.map { event in
                    event.color == Color.nextLightGray ? ColoredType(value: event.value, color: e.color, shape: event.shape) : event
                }
            }
        case .flatMapFirst:
            return aO!.flatMapFirst { e in
                bO!.map { event in
                    event.color == Color.nextLightGray ? ColoredType(value: event.value, color: e.color, shape: event.shape) : event
                }
            }
        case .flatMapLatest:
            return aO!.flatMapLatest { e in
                bO!.map { event in
                    event.color == Color.nextLightGray ? ColoredType(value: event.value, color: e.color, shape: event.shape) : event
                }
            }
            //        case .FlatMapWithIndex:
            //            return aO!.flatMapWithIndex { e, i
            //
        //            }
        case .ignoreElements:
            return aO!.ignoreElements().asObservable()
                .flatMapLatest { _ in
                    return Observable.never()
            }
        case .interval:
            return Observable<Int64>.interval(100, scheduler: scheduler).map { t in ColoredType(value: String(t), color: Color.nextRandom, shape: .circle) }
        case .just:
            return Observable.just(ColoredType(value: "", color: Color.nextRandom, shape: .circle))
        case .map:
            return aO!.map { h in
                guard let a = Int(h.value) else { throw RxError.unknown }
                return ColoredType(value: String(a * 10), color: h.color, shape: h.shape)
            }
        case .mapWithIndex:
            return aO!.enumerated().map { index, element in
                if index == 1 {
                    guard let a = Int(element.value) else { throw RxError.unknown }
                    return ColoredType(value: String(a * 10), color: element.color, shape: element.shape)
                } else {
                    return element
                }
            }
        case .merge:
            return Observable.of(aO!, bO!).merge()
        case .never:
            return Observable.never()
        case .of:
            return Observable.of(ColoredType(value: "1", color: Color.nextRandom, shape: .star))
        case .reduce:
            return aO!.reduce(ColoredType(value: "0", color: Color.nextGreen, shape: .circle)) {
                guard let a = Int($0.value), let b = Int($1.value) else { throw RxError.unknown }
                return ColoredType(value: String(a + b), color: $1.color, shape: $1.shape)
            }
        case .repeatElement:
            return Observable<Int64>.interval(150, scheduler: scheduler).map { _ in ColoredType(value: "1", color: Color.nextGreen, shape: .star)}
        case .retry:
            return aO!.retry(2)
        case .sample:
            return aO!.sample(bO!)
        case .scan:
            return aO!.scan(ColoredType(value: "0", color: Color.nextGreen, shape: .star)) { acc, e in
                guard let a = Int(e.value), let b = Int(acc.value) else { throw RxError.unknown }
                return ColoredType(value: String(a + b), color: e.color, shape: e.shape)
            }
        case .single:
            return aO!.single()
        case .skip:
            return aO!.skip(2)
        case .skipDuration:
            return aO!.skip(400, scheduler: scheduler)
        case .skipUntil:
            return aO!.skipUntil(bO!)
        case .skipWhile:
            return aO!.skipWhile { e in Int(e.value)! < 4 }
        case .skipWhileWithIndex:
            return aO!.enumerated()
                .skipWhile { index, _ in index < 4 }
                .map { _, element in element }
        case .startWith:
            return aO!.startWith(ColoredType(value: "1", color: Color.nextGreen, shape: .circle))
        case .switchLatest:
            return Observable.of(aO!, bO!).switchLatest()
        case .take:
            return aO!.take(2)
        case .takeDuration:
            return aO!.take(400, scheduler: scheduler)
        case .takeLast:
            return aO!.takeLast(2)
        case .takeUntil:
            return aO!.takeUntil(bO!)
        case .takeWhile:
            return aO!.takeWhile { e in Int(e.value)! < 4 }
        case .takeWhileWithIndex:
            return aO!.enumerated()
                .takeWhile { index, _ in index < 4 }
                .map { _, element in element  }
        case .throw:
            return Observable.error(RxError.unknown)
        case .timeout:
            return aO!.timeout(200, scheduler: scheduler)
        case .timer:
            return Observable<Int64>.timer(500, scheduler: scheduler).map { t in ColoredType(value: String(t), color: Color.nextRandom, shape: .circle) }
        case .toArray:
            return aO!
                .toArray()
                .map {
                    let values = $0.map {$0.value } .joined(separator: ", ")
                    return ColoredType(value: "[\(values)]", color: Color.nextGreen, shape: .rect)
            }
        case .withLatestFrom:
            return aO!.withLatestFrom(bO!)
        case .zip:
            return Observable.zip(aO!, bO!) {
                return ColoredType(value: $0.value + $1.value, color: $0.color, shape: $1.shape)
            }
        }
    }
}

extension Operator {
    var multiTimelines: Bool {
        switch self {
        case .amb, .combineLatest, .concat, .flatMap, .flatMapFirst, .flatMapLatest,
             .merge, .sample, .skipUntil, .switchLatest, .takeUntil, .withLatestFrom, .zip:
            return true
        default:
            return false
        }
    }
    
    var withoutTimelines: Bool {
        switch self {
        case .empty, .interval, .just, .never, .of, .repeatElement, .throw, .timer:
            return true
        default:
            return false
        }
    }
}

extension Operator {
    var urlString: String {
        switch self {
        case .catchError, .catchErrorJustReturn:
            return "catch.html"
        case .delaySubscription:
            return "delay.html"
        case .distinctUntilChanged:
            return "distinct.html"
        case .empty, .never, .throw:
            return "empty-never-throw.html"
        case .flatMap, .flatMapFirst, .flatMapLatest:
            return "flatmap.html"
        case .ignoreElements:
            return "ignoreelements.html"
        case .map:
            return "map.html"
        case .of:
            return "from.html"
        case .repeatElement:
            return "repeat.html"
        case .single:
            return "first.html"
        case .skipDuration:
            return "skip.html"
        case .skipWhile:
            return "skipwhile.html"
        case .switchLatest:
            return "switch.html"
        case .takeDuration:
            return "take.html"
        case .take:
            return "takewhile.html"
        case .throttle:
            return "debounce.html"
        case .toArray:
            return "to.html"
        case .withLatestFrom:
            return "combinelatest.html"
        default:
            return "\(rawValue.lowercased()).html"
        }
    }
    
    var url: URL {
        let reactivex = "http://reactivex.io/documentation/operators/"
        return URL(string: reactivex + urlString)!
    }
}

extension Operator {
    var text: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    var linkText: NSMutableAttributedString {
        let res = NSMutableAttributedString(string: text)
        let link = NSMutableAttributedString(string: "\(NSLocalizedString("read", comment: ""))\u{a0}\(NSLocalizedString("more", comment: ""))...", attributes: [.link: url])
        res.append(NSAttributedString(string: " "))
        res.append(link)
        res.addAttribute(.font, value: Font.code(.monoRegular, size: 16), range: NSMakeRange(0, res.length))
        res.addAttribute(.foregroundColor, value: Color.label, range: NSMakeRange(0, res.length))
        return res
    }
}
