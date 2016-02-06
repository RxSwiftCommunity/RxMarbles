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

let IndexVersion = "v1"

enum UserActivityType: String {
    case OperatorView
}

extension Operator {
    static var all: [Operator] {
        return
    [.Amb
    ,.Buffer
    ,.CatchError
    ,.CombineLatest
    ,.Concat
    ,.Debounce
    ,.DelaySubscription
    ,.DistinctUntilChanged
    ,.ElementAt
    ,.Empty
    ,.Filter
    ,.FlatMap
    ,.FlatMapFirst
    ,.FlatMapLatest
    ,.IgnoreElements
    ,.Just
    ,.Map
    ,.MapWithIndex
    ,.Merge
    ,.Never
    ,.Reduce
    ,.Retry
    ,.Sample
    ,.Scan
    ,.Skip
    ,.StartWith
    ,.Take
    ,.TakeLast
    ,.Throw
    ,.Zip
    ]
    }
}

extension Operator {
    func keywords() -> Set<String> {
        return ["Rx", "Reactive", "Operator", "Marbles", description]
    }
    
    func searchableAttributes() -> CSSearchableItemAttributeSet {
        let attributes = CSSearchableItemAttributeSet(itemContentType: "url")
        attributes.title = description
        attributes.contentDescription = "RxSwift \(self) operator diagram"
        attributes.keywords = Array<String>(keywords())
        attributes.identifier = rawValue
        attributes.relatedUniqueIdentifier = rawValue
        return attributes
    }
    
    func userActivity() -> NSUserActivity {
        let activity = NSUserActivity(activityType: UserActivityType.OperatorView.rawValue)
        activity.title = description
        activity.keywords = keywords()
        activity.eligibleForSearch = true
        activity.eligibleForPublicIndexing = true
        activity.userInfo = ["operator": self.rawValue]
        
        
        activity.contentAttributeSet = searchableAttributes()
        return activity
    }
    
    func searchableItem() -> CSSearchableItem {
        let item = CSSearchableItem(
            uniqueIdentifier: rawValue,
            domainIdentifier: "operators",
            attributeSet: searchableAttributes()
        )
        return item
    }
    
    static func index() {
        guard CSSearchableIndex.isIndexingAvailable() else { return }
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        let indexVersionKey = "indexVersion"
        
        if let indexVersion = userDefaults.stringForKey(indexVersionKey)
            where indexVersion == IndexVersion {
            debugPrint("already indexed")
            return
        }
        
        let index = CSSearchableIndex.defaultSearchableIndex()
        let items = Operator.all.map { $0.searchableItem() }
        index.deleteAllSearchableItemsWithCompletionHandler { error in
            if let e = error {
                debugPrint(e)
                return
            }
            
            index.indexSearchableItems(items, completionHandler: { error in
                if let e = error {
                    debugPrint("failed to index items")
                    debugPrint(e)
                    return
                }
                
                userDefaults.setObject(IndexVersion, forKey: indexVersionKey)
                userDefaults.synchronize()
            })
        }
    }
}