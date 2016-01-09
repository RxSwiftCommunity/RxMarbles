//
//  DelayScene.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 06.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import SpriteKit
import RxSwift

class DelayScene: TemplateScene {
    override func map(o: Observable<ColoredType>, scheduler: TestScheduler) -> Observable<ColoredType> {
        return o.delaySubscription(30, scheduler: scheduler)
    }
}