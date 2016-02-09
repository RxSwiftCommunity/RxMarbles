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
    func userActivity() -> NSUserActivity {
        let activity = NSUserActivity(activityType: UserActivityType.OperatorView.rawValue)
        activity.title = description
        activity.keywords = _keywords()
        activity.eligibleForSearch = true
        activity.eligibleForPublicIndexing = true
        activity.userInfo = ["operator": self.rawValue]
        
        
        activity.contentAttributeSet = _searchableAttributes()
        return activity
    }
    
    private func _keywords() -> Set<String> {
        return ["Rx", "Reactive", "Operator", "Marbles", description]
    }
    
    private func _searchableAttributes() -> CSSearchableItemAttributeSet {
        let attributes = CSSearchableItemAttributeSet(itemContentType: "url")
        attributes.title = description
        attributes.contentDescription = text
        attributes.keywords = Array<String>(_keywords())
        attributes.identifier = rawValue
        attributes.relatedUniqueIdentifier = rawValue
        return attributes
    }
    
    
    private func _searchableItem() -> CSSearchableItem {
        let item = CSSearchableItem(
            uniqueIdentifier: rawValue,
            domainIdentifier: "operators",
            attributeSet: _searchableAttributes()
        )
        return item
    }
    
    static func index() {
        guard CSSearchableIndex.isIndexingAvailable() else { return }
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        let indexVersionKey = "indexVersion"
        
        if let indexVersion = userDefaults.stringForKey(indexVersionKey)
            where indexVersion == IndexVersion {
            return debugPrint("already indexed")
        }
        
        let index = CSSearchableIndex.defaultSearchableIndex()
        let items = Operator.all.map { $0._searchableItem() }
        index.deleteAllSearchableItemsWithCompletionHandler { error in
            if let e = error {
                return debugPrint(e)
            }
            
            index.indexSearchableItems(items, completionHandler: { error in
                if let e = error {
                    return debugPrint("failed to index items \(e)")
                }
                
                userDefaults.setObject(IndexVersion, forKey: indexVersionKey)
                userDefaults.synchronize()
            })
        }
    }
}