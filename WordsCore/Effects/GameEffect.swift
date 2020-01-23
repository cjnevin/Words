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

public typealias GameEffect = AnyEffect<GameAction, GameDependencies>

public struct ValidationEffect: Effect {
    let oldBoard: Board
    let newBoard: Board

    init(state: GameState) {
        oldBoard = state.board
        newBoard = state.turn.board
    }

    public func mapToAction(dependencies: GameDependencies) -> AnyPublisher<GameAction, Never> {
        let placementResult = self.oldBoard.calculatePlacement(comparingWith: self.newBoard)
        switch placementResult {
        case let .failure(error):
            return Just(ValidationAction.Invalid(error: error)).eraseToAnyPublisher()
        case let .success(placement):
            switch placement.candidates(on: self.newBoard).validate(with: dependencies.validator) {
            case .invalidCandidates(let candidates):
                return Just(ValidationAction.Incorrect(candidates: candidates)).eraseToAnyPublisher()
            case .validCandidates(let candidates):
                let score = candidates.calculateScore(oldBoard: self.oldBoard, newBoard: self.newBoard)
                return Just(ValidationAction.Valid(score: score)).eraseToAnyPublisher()
            }
        }
    }
}

public struct NoEffect: Effect {
    public func mapToAction(dependencies: GameDependencies) -> AnyPublisher<GameAction, Never> {
        Empty().eraseToAnyPublisher()
    }
}
