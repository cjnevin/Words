//
//  NoEffect.swift
//  WordsCore
//
//  Created by Chris on 23/01/2020.
//  Copyright © 2020 Chris. All rights reserved.
//

import Foundation
import Combine
import Redux

struct NoEffect: Effect {
    func mapToAction(dependencies: GameDependencies) -> AnyPublisher<GameAction, Never> {
        Empty().eraseToAnyPublisher()
    }
}
