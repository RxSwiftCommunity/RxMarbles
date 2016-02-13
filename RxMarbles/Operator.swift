//
//  Operator.swift
//  RxMarbles
//
//  Created by Yury Korolev on 1/10/16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

enum Operator: String {
    case Amb
    case Buffer
    case CatchError
    case CatchErrorJustReturn
    case CombineLatest
    case Concat
    case Debounce
    case DelaySubscription
    case DistinctUntilChanged
    case ElementAt
    case Empty
    case Filter
    case FlatMap
    case FlatMapFirst
    case FlatMapLatest
//    case FlatMapWithIndex
    case IgnoreElements
    case Interval
    case Just
    case Map
    case MapWithIndex
    case Merge
    case Never
    case Of
    case Reduce
    case RepeatElement
    case Retry
    case Sample
    case Scan
    case Single
    case Skip
    case SkipDuration
    case SkipUntil
    case SkipWhile
    case SkipWhileWithIndex
    case StartWith
    case SwitchLatest
    case Take
    case TakeDuration
    case TakeLast
    case TakeUntil
    case TakeWhile
    case TakeWhileWithIndex
    case Throttle
    case Throw
    case Timeout
    case Timer
    case ToArray
    case WithLatestFrom
    case Zip
}

extension Operator: CustomStringConvertible {
    var description: String {
        return self.rawValue
    }
}


