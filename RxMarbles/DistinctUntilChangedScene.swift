//
//  DistinctUntilChangedScene.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 09.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import SpriteKit
import RxSwift

class DistinctUntilChangedScene: TemplateScene {
    //    MARK: distinctUntilChanged
    override func map(o: Observable<ColoredType>, scheduler: TestScheduler) -> Observable<ColoredType> {
        return o.distinctUntilChanged()
    }
}
