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
        var exchangingTiles: [Tile] = []
        var heldTile: Tile? = nil
        var isExchanging: Bool = false
        var invalidCandidates: [Candidate] = []
        var placementError: PlacementError?
        var score: Int = 0

        var canSubmit: Bool {
            return score > 0
                && heldTile == nil
                && placementError == nil
                && invalidCandidates.isEmpty
        }
    }

    public var isExchanging: Bool {
        return turn.isExchanging
    }

    public var rackTiles: [Tile] {
        let playerTiles = currentPlayer?.tiles ?? []
        if isExchanging {
            return playerTiles.filter { !turn.exchangingTiles.contains($0) }
        } else {
            return playerTiles
        }
    }

    public var selectedTiles: [Tile] {
        if isExchanging {
            return turn.exchangingTiles
        } else {
            return turn.heldTile.map { [$0] } ?? []
        }
    }

    public var latestBoard: Board {
        return turn.board
    }

    var heldTile: Tile? {
        return turn.heldTile
    }

    var board: Board = Board()
    public internal(set) var players: [Player] = []
    var playerIndex: Int = 0
    public internal(set) var tileBag: TileBag = TileBag()
    var turn: Turn = Turn()
    
    public var canSubmit: Bool {
        return turn.canSubmit
    }

    mutating func invalidateTurn() {
        turn.score = 0
        turn.placementError = nil
    }

    mutating func restoreRack() {
        let tiles = board.rightDiff(against: turn.board).compactMap { $0.tile }
        currentPlayer?.tiles.append(contentsOf: tiles)
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
