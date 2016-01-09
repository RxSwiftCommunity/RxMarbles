//
//  ReduceScene.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 09.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import SpriteKit
import RxSwift

class ReduceScene: TemplateScene {
    //    MARK: reduce
    override func map(o: Observable<ColoredType>, scheduler: TestScheduler) -> Observable<ColoredType> {
        return o.reduce(ColoredType(value: 0, color: .redColor()), accumulator: { acc, e in
            var res = acc
            res.value += e.value
            res.color = e.color
            return res
        })
    }
}
