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
        case Amb:
            return "a.amb(b)"
        case Buffer:
            return "a.buffer(timeSpan: 150, count: 3, scheduler: s)"
        case CatchError:
            return "a.catchError(1)"
        case CombineLatest:
            return "Observable.combineLatest(a, b) { $0 + $1 }"
        case Concat:
            return "[a, b].concat()"
        case Debounce:
            return "a.debounce(100, scheduler: s)"
        case DelaySubscription:
            return "a.delaySubscription(150, scheduler: s)"
        case DistinctUntilChanged:
            return "a.distinctUntilChanged()"
        case ElementAt:
            return "a.elementAt(2)"
        case Empty:
            return "Observable.empty()"
        case Filter:
            return "a.filter { $0 > 10 }"
        case FlatMap:
            return "a.flatMap(b)"
        case FlatMapFirst:
            return "a.flatMapFirst(b)"
        case FlatMapLatest:
            return "a.flatMapLatest(b)"
        case IgnoreElements:
            return "a.ignoreElements()"
        case Just:
            return "Observable.just()"
        case Map:
            return "a.map { $0 * 10 }"
        case MapWithIndex:
            return "a.mapWithIndex { e, i in i == 1 ? r * 10 : e }"
        case Merge:
            return "Observable.of(a, b).merge()"
        case Never:
            return "Observable.never()"
        case Reduce:
            return "a.reduce { $0 + $1 }"
        case Retry:
            return "a.retry(2)"
        case Sample:
            return "a.sample(b)"
        case Scan:
            return "a.scan(0) { $0 + $1 }"
        case Skip:
            return "a.skip(2)"
        case StartWith:
            return "a.startWith(1)"
        case Take:
            return "a.take(2)"
        case TakeLast:
            return "a.takeLast(1)"
        case Throw:
            return "Observable.error()"
        case Window:
            return "a.window(timeSpan: 300, count: 2, scheduler: s)"
        case Zip:
            return "Observable.zip(a, b) { $0 + $1 }"
        }
    }
}

//NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\b(a|b)(c|d)\\b"

let __methodRegex = try? NSRegularExpression(pattern: "\\.[^\\s\\(\\{]+", options: .CaseInsensitive)
let __typeRegex = try? NSRegularExpression(pattern: "Observable", options: .CaseInsensitive)
let __numberRegex = try? NSRegularExpression(pattern: "[^\\$](\\d+)", options: .CaseInsensitive)

extension Operator {
    func higlightedCode() -> NSAttributedString {
        let font = UIFont(name: "Menlo-Regular", size: 18)!
        let src = NSMutableAttributedString(string: code, attributes: [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: Color.codeDefault
        ])
        let str = src.string as NSString
        
        let methods = __methodRegex!.matchesInString(src.string, options: [], range: NSMakeRange(0, str.length))
        
        for m in methods {
            let r = m.range
            src.setAttributes([
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: Color.codeMethod
            ], range: r)
        }
        
        let numbers = __numberRegex!.matchesInString(src.string, options: [], range: NSMakeRange(0, str.length))
        
        for n in numbers {
            let r = n.rangeAtIndex(1)
            src.setAttributes([
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: Color.codeNumber
            ], range: r)
        }
        
        let types = __typeRegex!.matchesInString(src.string, options: [], range: NSMakeRange(0, str.length))
        
        for t in types {
            src.setAttributes([
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: Color.codeType
            ], range: t.range)
        }
        
        return src
    }
}