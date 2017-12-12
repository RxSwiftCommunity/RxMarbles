//
//  Operator.swift
//  RxMarbles
//
//  Created by Yury Korolev on 1/10/16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

enum Operator: String {
    case amb
    case buffer
    case catchError
    case catchErrorJustReturn
    case combineLatest
    case concat
    case debounce
    case delaySubscription
    case distinctUntilChanged
    case elementAt
    case empty
    case filter
    case flatMap
    case flatMapFirst
    case flatMapLatest
    case ignoreElements
    case interval
    case just
    case map
    case mapWithIndex
    case merge
    case never
    case of
    case reduce
    case repeatElement
    case retry
    case sample
    case scan
    case single
    case skip
    case skipDuration
    case skipUntil
    case skipWhile
    case skipWhileWithIndex
    case startWith
    case switchLatest
    case take
    case takeDuration
    case takeLast
    case takeUntil
    case takeWhile
    case takeWhileWithIndex
    case throttle
    case `throw`
    case timeout
    case timer
    case toArray
    case withLatestFrom
    case zip
}

extension Operator: CustomStringConvertible {
    var description: String {
        return self.rawValue
    }
}


