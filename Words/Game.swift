//
//  Game.swift
//  words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import Redux
import WordsCore

extension GameStore {
    static var preview: GameStore {
        let store = GameStore(
            initialState: GameState(
                board: Board(spots: .defaultLayout),
                players: .preview),
            reducer: GameReducer(),
            dependencies: .real,
            effectQueue: .global())
        store.add(middleware: ActionDebugMiddleware())
        return store
    }
}

extension GameDependencies {
    static var real: GameDependencies {
        return GameDependencies(validator: RealWordValidator())
    }
}

private struct RealWordValidator: WordValidator {
    func validate(word: String) -> Bool {
        return true
    }
}

private extension Sequence where Element == Player {
    static var preview: [Player] {
        [.player1, .player2]
    }
}

private extension Player {
    static var player1: Player {
        Player(name: "Player 1", tiles: Tile.preview, score: 100)
    }

    static var player2: Player {
        Player(name: "Player 2", tiles: Tile.preview.reversed(), score: 250)
    }
}
