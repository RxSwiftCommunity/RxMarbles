//
//  TakeLastScene.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 09.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import SpriteKit
import RxSwift

class TakeLastScene: TemplateScene {
    //    MARK: takeLast
    override func map(o: Observable<ColoredType>, scheduler: TestScheduler) -> Observable<ColoredType> {
        return o.takeLast(2)
    }
}
