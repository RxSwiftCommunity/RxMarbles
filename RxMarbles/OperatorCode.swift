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
        case .amb:
            return "a.amb(b)"
        case .buffer:
            return "a.buffer(timeSpan: 150, count: 3, scheduler: s)"
        case .catchError:
            return "a.catchError { _ in .just(1) }"
        case .catchErrorJustReturn:
            return "a.catchErrorJustReturn(1)"
        case .combineLatest:
            return "Observable.combineLatest(a, b) { $0 + $1 }"
        case .concat:
            return "[a, b].concat()"
        case .debounce:
            return "a.debounce(100, scheduler: s)"
        case .delaySubscription:
            return "a.delaySubscription(150, scheduler: s)"
        case .distinctUntilChanged:
            return "a.distinctUntilChanged()"
        case .elementAt:
            return "a.elementAt(2)"
        case .empty:
            return "Observable.empty()"
        case .filter:
            return "a.filter { $0 > 10 }"
        case .flatMap:
            return "a.flatMap(b)"
        case .flatMapFirst:
            return "a.flatMapFirst(b)"
        case .flatMapLatest:
            return "a.flatMapLatest(b)"
        case .ignoreElements:
            return "a.ignoreElements()"
        case .interval:
            return "Observable.interval<Int64>(100, scheduler: s).map { $0 }"
        case .just:
            return "Observable.just()"
        case .map:
            return "a.map { $0 * 10 }"
        case .mapWithIndex:
            return "a.mapWithIndex { e, i in i == 1 ? e * 10 : e }"
        case .merge:
            return "Observable.of(a, b).merge()"
        case .never:
            return "Observable.never()"
        case .of:
            return "Observable.of()"
        case .reduce:
            return "a.reduce { $0 + $1 }"
        case .repeatElement:
            return "Observable.repeatElement(1)"
        case .retry:
            return "a.retry(2)"
        case .sample:
            return "a.sample(b)"
        case .scan:
            return "a.scan(0) { $0 + $1 }"
        case .single:
            return "a.single()"
        case .skip:
            return "a.skip(2)"
        case .skipDuration:
            return "a.skip(400, scheduler: scheduler)"
        case .skipUntil:
            return "a.skipUntil(b)"
        case .skipWhile:
            return "a.skipWhile { $0 < 4 }"
        case .skipWhileWithIndex:
            return "a.skipWhileWithIndex { e, i in i < 4 }"
        case .startWith:
            return "a.startWith(1)"
        case .switchLatest:
            return "Observable.of(a, b).switchLatest()"
        case .take:
            return "a.take(2)"
        case .takeDuration:
            return "a.take(400, scheduler: scheduler)"
        case .takeLast:
            return "a.takeLast(2)"
        case .takeUntil:
            return "a.takeUntil(b)"
        case .takeWhile:
            return "a.takeWhile { $0 < 4 }"
        case .takeWhileWithIndex:
            return "a.takeWhileWithIndex { e, i in i < 4 }"
        case .throttle:
            return "a.throttle(100, scheduler: s)"
        case .throw:
            return "Observable.error()"
        case .timeout:
            return "a.timeout(200, scheduler: s)"
        case .timer:
            return "Observable<Int64>.timer(500, scheduler: s).map { $0 }"
        case .toArray:
            return "a.toArray()"
        case .withLatestFrom:
            return "a.withLatestFrom(b)"
        case .zip:
            return "Observable.zip(a, b) { $0 + $1 }"
        }
    }
}

private let __methodRegex = try? NSRegularExpression(pattern: "\\.[^\\s\\(\\{]+", options: [])
private let __typeRegex = try? NSRegularExpression(pattern: "(Observable)|(Int64)", options: [])
private let __keywordRegex = try? NSRegularExpression(pattern: "\\bin\\b", options: [])
private let __numberRegex = try? NSRegularExpression(pattern: "[^\\$](\\d+)", options: [])

private func __colorize(_ src: NSMutableAttributedString, regex: NSRegularExpression, rangeIndex: Int, attrs: [NSAttributedString.Key: Any]) {
    
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
        let src = NSMutableAttributedString(string: code, attributes: [.font: font, .foregroundColor: Color.codeDefault])
        
        __colorize(src, regex: __methodRegex!, rangeIndex: 0, attrs: [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): Color.codeMethod
            ]
        )
        __colorize(src, regex: __numberRegex!, rangeIndex: 1, attrs: [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): Color.codeNumber
            ]
        )
        
        __colorize(src, regex: __typeRegex!, rangeIndex: 0, attrs: [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): Color.codeType
            ]
        )
        
        __colorize(src, regex: __keywordRegex!, rangeIndex: 0, attrs: [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): Color.codeKeyword
            ]
        )
        
        return src
    }
}
