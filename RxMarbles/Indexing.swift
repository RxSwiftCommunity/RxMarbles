//
//  Indexing.swift
//  RxMarbles
//
//  Created by Yury Korolev on 1/22/16.
//  Copyright © 2016 AnjLab. All rights reserved.
//

import Foundation
import RxSwift
import CoreSpotlight

private let IndexVersion = "v2"

enum UserActivityType: String {
    case OperatorView
}

extension Operator {
    static var all: [Operator] {
        return
            [.amb,
             .buffer,
             .catchError,
             .catchErrorJustReturn,
             .combineLatest,
             .concat,
             .debounce,
             .delaySubscription,
             .distinctUntilChanged,
             .elementAt,
             .empty,
             .filter,
             .flatMap,
             .flatMapFirst,
             .flatMapLatest,
             .ignoreElements,
             .interval,
             .just,
             .map,
             .mapWithIndex,
             .merge,
             .never,
             .of,
             .reduce,
             .repeatElement,
             .retry,
             .sample,
             .scan,
             .single,
             .skip,
             .skipDuration,
             .skipUntil,
             .skipWhile,
             .skipWhileWithIndex,
             .startWith,
             .switchLatest,
             .take,
             .takeDuration,
             .takeLast,
             .takeUntil,
             .takeWhile,
             .takeWhileWithIndex,
             .throttle,
             .throw,
             .timeout,
             .timer,
             .toArray,
             .withLatestFrom,
             .zip
        ]
    }
}

extension Operator {
    func userActivity() -> NSUserActivity {
        let activity = NSUserActivity(activityType: UserActivityType.OperatorView.rawValue)
        
        activity.title = description
        activity.keywords = keywords()
        activity.isEligibleForSearch = true
        activity.isEligibleForPublicIndexing = true
        activity.userInfo = ["operator": rawValue]
        
        
        activity.contentAttributeSet = searchableAttributes()
        return activity
    }
    
    private func keywords() -> Set<String> {
        return ["Rx", "Reactive", "Operator", "Marbles", description]
    }
    
    private func searchableAttributes() -> CSSearchableItemAttributeSet {
        let attributes = CSSearchableItemAttributeSet(itemContentType: "url")
        
        attributes.title = description
        attributes.contentDescription = text
        attributes.keywords = Array<String>(keywords())
        attributes.identifier = rawValue
        attributes.relatedUniqueIdentifier = rawValue
        
        return attributes
    }
    
    
    private func searchableItem() -> CSSearchableItem {
        return CSSearchableItem(
            uniqueIdentifier: rawValue,
            domainIdentifier: "operators",
            attributeSet: searchableAttributes()
        )
    }
    
    static func index() {
        guard CSSearchableIndex.isIndexingAvailable() else { return }
        
        let userDefaults = UserDefaults.standard
        
        let indexVersionKey = "indexVersion"
        
        if let indexVersion = userDefaults.string(forKey: indexVersionKey)
            , indexVersion == IndexVersion {
            return debugPrint("already indexed")
        }
        
        let index = CSSearchableIndex.default()
        let items = Operator.all.map { $0.searchableItem() }
        index.deleteAllSearchableItems { error in
            if let e = error {
                return debugPrint(e)
            }
            
            index.indexSearchableItems(items, completionHandler: { error in
                if let e = error {
                    return debugPrint("failed to index items \(e)")
                }
                
                userDefaults.set(IndexVersion, forKey: indexVersionKey)
                userDefaults.synchronize()
            })
        }
    }
}
