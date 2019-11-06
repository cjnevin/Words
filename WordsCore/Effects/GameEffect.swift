//
//  GameEffect.swift
//  words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import Combine
import Redux

struct ValidationEffect: Effect {
    let oldBoard: Board
    let newBoard: Board

    func mapToAction(dependencies: GameDependencies) -> AnyPublisher<GameAction, Never> {
        let subject = PassthroughSubject<GameAction, Never>()
        dependencies.backgroundDispatch {
            let candidates = CompoundPlacement(oldBoard: self.oldBoard, newBoard: self.newBoard).candidates(on: self.newBoard)
            switch candidates {
            case let .invalidPlacements(placements):
                subject.send(ValidationAction.Misplaced(placements: placements))
            case let .candidates(candidates):
                switch candidates.validate(with: dependencies.validator) {
                case let .invalidCandidates(candidates):
                    subject.send(ValidationAction.Invalid(candidates: candidates))
                case let .validCandidates(candidates):
                    let score = candidates.calculateScore(oldBoard: self.oldBoard, newBoard: self.newBoard)
                    subject.send(ValidationAction.Valid(score: score))
                }
            }
        }
        return subject.eraseToAnyPublisher()
    }
}
