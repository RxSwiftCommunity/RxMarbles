//
//  StartWithScene.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 09.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import SpriteKit
import RxSwift

class StartWithScene: TemplateScene {
    //    MARK: startWith
    override func map(o: Observable<ColoredType>, scheduler: TestScheduler) -> Observable<ColoredType> {
        return o.startWith(ColoredType(value: 2, color: RXMUIKit.randomColor()))
    }
}
