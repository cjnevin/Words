//
//  GameEffect.swift
//  words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import Redux

public typealias GameEffect = AnyEffect<GameAction, GameDependencies>

extension GameEffect {
    static var none: GameEffect { NoEffect().eraseToAnyEffect() }
    static func validate(state: GameState) -> GameEffect { ValidationEffect(state: state).eraseToAnyEffect() }
}
