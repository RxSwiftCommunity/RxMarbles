//
//  Operator.swift
//  RxMarbles
//
//  Created by Yury Korolev on 1/10/16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

enum Operator: String {
    case Amb
    case Buffer
    case CatchError
    case CombineLatest
    case Concat
    case Debounce
    case Delay
    case DistinctUntilChanged
    case ElementAt
    case Empty
    case Filter
    case FlatMap
    case FlatMapFirst
    case FlatMapLatest
    case IgnoreElements
    case Just
    case Map
    case MapWithIndex
    case Merge
    case Never
    case Reduce
    case Retry
    case Sample
    case Scan
    case Skip
    case StartWith
    case Take
    case TakeLast
    case Throw
    case Zip
}


extension Operator: CustomStringConvertible {
    var description: String {
        return self.rawValue
    }
}


