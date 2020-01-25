//
//  GameState.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

public struct BoardSpot: Codable {
    public enum Status: Int, Codable {
        case `default`
        case invalid
        case valid
    }
    public let spot: Spot
    public let status: Status
}

public struct GameState: Codable {
    struct Turn: Codable {
        var board: Board = Board()
        var exchangingTiles: [Tile] = []
        var heldTile: Tile? = nil
        var isExchanging: Bool = false
        var validCandidates: [Candidate] = []
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
        turn.isExchanging
    }

    public var rackTiles: [Tile] {
        let playerTiles = currentPlayer?.tiles ?? []
        if isExchanging {
            return playerTiles.filter { !turn.exchangingTiles.contains($0) }
        } else {
            return playerTiles
        }
    }

    public var words: [String] {
        turn.validCandidates.words
    }

    public var selectedTiles: [Tile] {
        if isExchanging {
            return turn.exchangingTiles
        } else {
            return turn.heldTile.map { [$0] } ?? []
        }
    }

    public var spots: [[Spot]] {
        let validSpots = turn.validCandidates.spots
        let invalidSpots = turn.invalidCandidates.spots
        return turn.board.spots.map { row in
            row.map { column in
                var copy = column
                if validSpots.contains(column) {
                    copy.status = .valid
                } else if invalidSpots.contains(column) {
                    copy.status = .invalid
                } else {
                    copy.status = .default
                }
                return copy
            }
        }
    }

    var heldTile: Tile? {
        turn.heldTile
    }

    var board: Board = Board()
    public internal(set) var players: [Player] = []
    var playerIndex: Int = 0
    public internal(set) var tileBag: TileBag = TileBag()
    var turn: Turn = Turn()

    public var canReturnAll: Bool {
        turn.board != board
    }

    public var canSubmit: Bool {
        turn.canSubmit
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
