//
//  GameState.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

public struct GameState: Codable {
    struct Turn: Codable {
        var board: Board = Board()
        var heldTile: Tile? = nil
        var misplacedSpots: [Placement] = []
        var invalidCandidates: [Candidate] = []
        var score: Int = 0

        var canSubmit: Bool {
            return score > 0 && heldTile == nil
        }
    }

    public var latestBoard: Board {
        return turn.board
    }

    var board: Board = Board()
    public internal(set) var players: [Player] = []
    var playerIndex: Int = 0
    public internal(set) var tileBag: TileBag = TileBag()
    var turn: Turn = Turn()
    
    public var canSubmit: Bool {
        return turn.canSubmit
    }

    mutating func nextPlayer() {
        playerIndex = (playerIndex + 1) % players.count
        turn = .init(board: board)
    }
}

extension GameState {
    public init(
        board: Board = Board(),
        players: [Player] = [],
        tileBag: TileBag = TileBag()) {
        self.board = board
        self.players = players
        self.playerIndex = 0
        self.tileBag = tileBag
        self.turn = Turn(board: board)
    }
}

extension GameState {
    public internal(set) var currentPlayer: Player? {
        get {
            return players.indices.contains(playerIndex) ? players[playerIndex] : nil
        }
        set {
            if players.indices.contains(playerIndex), let newValue = newValue {
                players[playerIndex] = newValue
            }
        }
    }
}
