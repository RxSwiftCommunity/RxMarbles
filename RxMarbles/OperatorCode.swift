//
//  OperatorCode.swift
//  RxMarbles
//
//  Created by Yury Korolev on 2/3/16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import Foundation
import UIKit

extension Operator {
    var code: String {
        switch self {
        case .Amb:
            return "a.amb(b)"
        case .Buffer:
            return "a.buffer(timeSpan: 150, count: 3, scheduler: s)"
        case .CatchError:
            return "a.catchError { _ in .just(1) }"
        case .CatchErrorJustReturn:
            return "a.catchErrorJustReturn(1)"
        case .CombineLatest:
            return "Observable.combineLatest(a, b) { $0 + $1 }"
        case .Concat:
            return "[a, b].concat()"
        case .Debounce:
            return "a.debounce(100, scheduler: s)"
        case .DelaySubscription:
            return "a.delaySubscription(150, scheduler: s)"
        case .DistinctUntilChanged:
            return "a.distinctUntilChanged()"
        case .ElementAt:
            return "a.elementAt(2)"
        case .Empty:
            return "Observable.empty()"
        case .Filter:
            return "a.filter { $0 > 10 }"
        case .FlatMap:
            return "a.flatMap(b)"
        case .FlatMapFirst:
            return "a.flatMapFirst(b)"
        case .FlatMapLatest:
            return "a.flatMapLatest(b)"
        case .IgnoreElements:
            return "a.ignoreElements()"
        case .Interval:
            return "Observable.interval<Int64>(100, scheduler: s).map { $0 }"
        case .Just:
            return "Observable.just()"
        case .Map:
            return "a.map { $0 * 10 }"
        case .MapWithIndex:
            return "a.mapWithIndex { e, i in i == 1 ? e * 10 : e }"
        case .Merge:
            return "Observable.of(a, b).merge()"
        case .Never:
            return "Observable.never()"
        case .Of:
            return "Observable.of()"
        case .Reduce:
            return "a.reduce { $0 + $1 }"
        case .RepeatElement:
            return "Observable.repeatElement(1)"
        case .Retry:
            return "a.retry(2)"
        case .Sample:
            return "a.sample(b)"
        case .Scan:
            return "a.scan(0) { $0 + $1 }"
        case .Single:
            return "a.single()"
        case .Skip:
            return "a.skip(2)"
        case .SkipDuration:
            return "a.skip(400, scheduler: scheduler)"
        case .SkipUntil:
            return "a.skipUntil(b)"
        case .SkipWhile:
            return "a.skipWhile { $0 < 4 }"
        case .StartWith:
            return "a.startWith(1)"
        case .SwitchLatest:
            return "Observable.of(a, b).switchLatest()"
        case .Take:
            return "a.take(2)"
        case .TakeDuration:
            return "a.take(400, scheduler: scheduler)"
        case .TakeLast:
            return "a.takeLast(2)"
        case .TakeUntil:
            return "a.takeUntil(b)"
        case .TakeWhile:
            return "a.takeWhile { $0 < 4 }"
        case .Throttle:
            return "a.throttle(100, scheduler: s)"
        case .Throw:
            return "Observable.error()"
        case .Timeout:
            return "a.timeout(200, scheduler: s)"
        case .Timer:
            return "Observable<Int64>.timer(500, scheduler: s).map { $0 }"
        case .ToArray:
            return "a.toArray()"
        case .WithLatestFrom:
            return "a.withLatestFrom(b)"
        case .Zip:
            return "Observable.zip(a, b) { $0 + $1 }"
        }
    }
}

private let __methodRegex = try? NSRegularExpression(pattern: "\\.[^\\s\\(\\{]+", options: [])
private let __typeRegex = try? NSRegularExpression(pattern: "(Observable)|(Int64)", options: [])
private let __keywordRegex = try? NSRegularExpression(pattern: "\\bin\\b", options: [])
private let __numberRegex = try? NSRegularExpression(pattern: "[^\\$](\\d+)", options: [])

private func __colorize(_ src: NSMutableAttributedString, regex: NSRegularExpression, rangeIndex: Int, attrs: [NSAttributedStringKey: Any]) {
    
    let str = src.string as NSString
    
    let matches = regex.matches(in: src.string, options: [], range: NSMakeRange(0, str.length))
    
    for m in matches {
        let r = m.range(at: rangeIndex)
        src.setAttributes(attrs, range: r)
    }
}

extension Operator {
    func higlightedCode() -> NSAttributedString {
        let font = Font.code(.monoRegular, size:18)
        let src = NSMutableAttributedString(string: code, attributes: [
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.foregroundColor: Color.codeDefault
        ])
        
        __colorize(src, regex: __methodRegex!, rangeIndex: 0, attrs: [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): Color.codeMethod
            ]
        )
        __colorize(src, regex: __numberRegex!, rangeIndex: 1, attrs: [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): Color.codeNumber
            ]
        )
        
        __colorize(src, regex: __typeRegex!, rangeIndex: 0, attrs: [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): Color.codeType
            ]
        )
        
        __colorize(src, regex: __keywordRegex!, rangeIndex: 0, attrs: [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): Color.codeKeyword
            ]
        )
        
        return src
    }
}
