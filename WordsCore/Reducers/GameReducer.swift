//
//  GameReducer.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import Redux

public let gameReducer: Reducer<GameState, GameAction> = Reducer { state, action in
    switch action {
    case let createBag as BagAction.Reset:
        state.tileBag.tiles = createBag.distribution.reduce(into: [], { tiles, keyValue in
            let (amount, item) = keyValue
            let (face, value) = item
            tiles += (0..<amount).reduce(into: []) {
                $0.append(Tile(id: "\(face)\($1)", face: face, value: value))
            }
        })

    case let placeTile as RackAction.Place:
        guard let heldTile = state.turn.heldTile else {
            preconditionFailure("Held tile should not be null.")
        }
        var spot = placeTile.spot
        if spot.tile == nil {
            spot.tile = heldTile
            state.turn.board.spots[placeTile.spot.row][placeTile.spot.column] = spot
        } else {
            state.players[state.playerIndex].tiles.append(heldTile)
        }
        state.turn.heldTile = nil

    case let pickUpTile as RackAction.PickUp:
        guard var player = state.currentPlayer else {
            preconditionFailure("No current player.")
        }
        precondition(player.tiles.contains(pickUpTile.tile), "Player is not holding this tile.")
        precondition(state.turn.heldTile == nil, "Held tile should be null.")
        state.turn.heldTile = pickUpTile.tile
        player.remove(tiles: [pickUpTile.tile])
        state.currentPlayer = player

    case let returnTile as RackAction.Return:
        var spot = returnTile.spot
        spot.tile = nil
        state.turn.board.spots[returnTile.spot.row][returnTile.spot.column] = spot

    case is RackAction.ReturnAll:
        state.turn.board = state.board

    case is RackAction.Shuffle:
        state.currentPlayer?.shuffle()

    case let invalid as ValidationAction.Invalid:
        state.turn.invalidCandidates = invalid.candidates
        state.turn.score = 0
        state.turn.misplacedSpots = []

    case let valid as ValidationAction.Valid:
        state.turn.invalidCandidates = []
        state.turn.score = valid.score
        state.turn.misplacedSpots = []

    case let misplaced as ValidationAction.Misplaced:
        state.turn.invalidCandidates = []
        state.turn.score = 0
        state.turn.misplacedSpots = misplaced.placements

    case let exchangeTiles as TurnAction.Exchange:
        guard var player = state.currentPlayer else {
            preconditionFailure("No current player.")
        }
        state.tileBag.tiles += exchangeTiles.tiles
        var copy = state
        player.swap(tiles: exchangeTiles.tiles, replenish: { copy.tileBag.takeOne() })
        copy.currentPlayer = player
        state = copy
        state.nextPlayer()

    case is TurnAction.Submit:
        guard var player = state.currentPlayer else {
            preconditionFailure("No current player.")
        }
        precondition(state.turn.canSubmit)
        player.score += state.turn.score
        state.currentPlayer = player
        state.board = state.turn.board
        state.nextPlayer()

    case is TurnAction.Skip:
        precondition(state.currentPlayer != nil, "No current player.")
        precondition(state.turn.heldTile == nil, "Player is holding a tile.")
        state.nextPlayer()

    default:
        break
    }
}
