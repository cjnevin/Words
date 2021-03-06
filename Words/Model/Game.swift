//
//  Game.swift
//  words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import UIKit
import Redux
import WordsCore

extension GameStore {
    static var `default`: GameStore {
        let store = GameStore(
            initialState: GameState(),
            reducer: GameReducer(),
            dependencies: .real,
            effectQueue: .global())
        store.add(middleware: ActionDebugMiddleware())
        store.send(TurnAction.NewGame(players: ["Player 1", "Player 2"]))
        return store
    }
}

extension GameDependencies {
    static var real: GameDependencies {
        if let data = NSDataAsset(name: "dictionarySOWPODS")?.data,
            let dictionary = AnagramDictionary(data: data) {
            return GameDependencies(validator: dictionary)
        } else {
            return GameDependencies(validator: AnagramDictionary(words: [:]))
        }
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
