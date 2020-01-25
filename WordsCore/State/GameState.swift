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
        var placementError: PlacementError?
        var score: Int = 0
        var words: [String] = []

        var canSubmit: Bool {
            return score > 0
                && heldTile == nil
                && placementError == nil
                && !words.isEmpty
        }
    }

    public var substituteTiles: [Tile] {
        isSubstituting ? TileBag.defaultDistribution.elements.map { Tile(face: $0.face, value: 0) } : []
    }

    var isTakeOverShown: Bool {
        isSubstituting || isExchanging
    }

    public var isSubstituting: Bool {
        turn.heldTile?.face == "?"
    }

    public var isExchanging: Bool {
        turn.isExchanging
    }

    public var rackTiles: [Tile] {
        let playerTiles = (currentPlayer?.tiles ?? [])
            .compactMap { $0 == heldTile ? heldTile : $0 }
        return isExchanging
            ? playerTiles.filter { !turn.exchangingTiles.contains($0) }
            : playerTiles
    }

    public var selectedTiles: [Tile] {
        isExchanging ? turn.exchangingTiles : turn.heldTile.map { [$0] } ?? []
    }

    public var words: [String] {
        isTakeOverShown ? [] : turn.words
    }

    public var tentativeScore: Int {
        turn.score
    }

    public var spots: [[Spot]] {
        isTakeOverShown ? [] : turn.board.spots
    }

    var heldTile: Tile? {
        turn.heldTile
    }

    var board: Board = Board()
    public internal(set) var isGameOver: Bool = false
    public internal(set) var players: [Player] = []
    var playerIndex: Int = 0
    public internal(set) var tileBag: TileBag = TileBag()
    var turn: Turn = Turn()

    public var canReturnAll: Bool {
        turn.board != board
    }

    public var canSubmit: Bool {
        turn.canSubmit && !isGameOver
    }

    mutating func restoreRack() {
        let unfixedSpots = turn.board.spots.doesNotContainStatus(.fixed)
        let tiles = board.spots.newlyFilled(unfixedSpots).flatMap { $0.compactMap { $0.tile?.movable == true ? $0.tile : nil } }
        currentPlayer?.tiles.append(contentsOf: tiles.unique)
    }

    mutating func nextPlayer() {
        if currentPlayer?.tiles.isEmpty == true {
            isGameOver = true
            turn = .init(board: board)
        } else {
            playerIndex = (playerIndex + 1) % players.count
            turn = .init(board: board)
        }
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
