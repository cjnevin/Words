//
//  Game.swift
//  words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import WordsCore

extension GameStore {
    static var preview: GameStore {
        return GameStore(
        initialState: GameState(
            board: Board(spots: .defaultLayout),
            players: .preview),
        reducer: gameReducer,
        dependencies: .real)
    }
}

extension GameDependencies {
    static var real: GameDependencies {
        return GameDependencies(
            backgroundDispatch: { DispatchQueue.global(qos: .background).async(execute: $0) },
            validator: RealWordValidator())
    }
}

private struct RealWordValidator: WordValidator {
    func validate(word: String) -> Bool {
        return true
    }
}

private extension Sequence where Element == Player {
    static var preview: [Player] {
        [.preview]
    }
}

private extension Player {
    static var preview: Player {
        Player(tiles: Tile.preview, score: 0)
    }
}
