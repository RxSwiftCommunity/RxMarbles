//
//  MapScene.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 09.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import SpriteKit
import RxSwift

class MapScene: TemplateScene {
    //    MARK: map
    override func map(o: Observable<ColoredType>, scheduler: TestScheduler) -> Observable<ColoredType> {
        return o.map({ h in ColoredType(value: h.value * 10, color: h.color) })
    }
}
