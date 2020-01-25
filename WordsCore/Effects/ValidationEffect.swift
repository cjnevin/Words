//
//  ValidationEffect.swift
//  WordsCore
//
//  Created by Chris on 23/01/2020.
//  Copyright © 2020 Chris. All rights reserved.
//

import Foundation
import Combine
import Redux

struct ValidationEffect: Effect {
    let oldBoard: Board
    let newBoard: Board

    init(state: GameState) {
        oldBoard = state.board
        newBoard = state.turn.board
    }

    func mapToAction(dependencies: GameDependencies) -> AnyPublisher<GameAction, Never> {
        switch oldBoard.calculatePlacement(comparingWith: newBoard) {
        case let .failure(error):
            return Just(ValidationAction.Invalid(error: error)).eraseToAnyPublisher()
        case let .success(placement):
            switch placement.candidates(on: newBoard).validate(with: dependencies.validator) {
            case let .invalidCandidates(candidates):
                return Just(ValidationAction.Incorrect(candidates: candidates)).eraseToAnyPublisher()
            case let .validCandidates(candidates):
                let score = candidates.calculateScore(oldBoard: oldBoard, newBoard: newBoard)
                return Just(ValidationAction.Valid(score: score, candidates: candidates)).eraseToAnyPublisher()
            }
        }
    }
}
