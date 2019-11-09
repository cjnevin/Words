//
//  GameReducer.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import Redux

public typealias GameStore = Store<GameReducer>

public struct GameReducer: Reducer {
    public init() { }
    public func reduce(state: inout GameState, action: GameAction) -> GameEffect {
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
            guard var player = state.currentPlayer else {
                preconditionFailure("No current player.")
            }
            guard let heldTile = state.turn.heldTile else {
                return NoEffect().eraseToAnyEffect()
            }
            precondition(player.tiles.contains(heldTile), "Player is not holding this tile.")
            var spot = placeTile.spot
            if spot.tile == nil {
                spot.tile = heldTile
                state.turn.board.spots[placeTile.spot.row][placeTile.spot.column] = spot
                player.remove(tiles: [heldTile])
                state.currentPlayer = player
            }
            state.turn.heldTile = nil
            state.invalidateTurn()
            return ValidationEffect(oldBoard: state.board, newBoard: state.turn.board).eraseToAnyEffect()

        case let pickUpTile as RackAction.PickUp:
            guard let player = state.currentPlayer else {
                preconditionFailure("No current player.")
            }
            precondition(player.tiles.contains(pickUpTile.tile), "Player is not holding this tile.")
            state.turn.heldTile = pickUpTile.tile
            state.invalidateTurn()

        case let returnTile as RackAction.Return:
            guard var player = state.currentPlayer else {
                preconditionFailure("No current player.")
            }
            guard let tile = returnTile.spot.tile else {
                preconditionFailure("Return tile should not be null.")
            }
            var spot = returnTile.spot
            spot.tile = nil
            state.turn.board.spots[returnTile.spot.row][returnTile.spot.column] = spot
            state.invalidateTurn()
            player.tiles.append(tile)
            state.currentPlayer = player
            return ValidationEffect(oldBoard: state.board, newBoard: state.turn.board).eraseToAnyEffect()

        case is RackAction.ReturnAll:
            state.restoreRack()
            state.turn.board = state.board
            state.invalidateTurn()
            return ValidationEffect(oldBoard: state.board, newBoard: state.turn.board).eraseToAnyEffect()

        case is RackAction.Shuffle:
            state.currentPlayer?.shuffle()

        case let invalid as ValidationAction.Invalid:
            state.turn.placementError = invalid.error
            state.turn.score = 0

        case let valid as ValidationAction.Valid:
            state.turn.placementError = nil
            state.turn.score = valid.score

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
            return ValidationEffect(oldBoard: state.board, newBoard: state.turn.board).eraseToAnyEffect()

        case is TurnAction.Submit:
            guard var player = state.currentPlayer else {
                preconditionFailure("No current player.")
            }
            precondition(state.turn.canSubmit, "Submission not possible.")
            player.score += state.turn.score
            state.currentPlayer = player
            state.board = state.turn.board
            state.nextPlayer()

        case is TurnAction.Skip:
            precondition(state.currentPlayer != nil, "No current player.")
            state.restoreRack()
            state.nextPlayer()

        default:
            break
        }

        return NoEffect().eraseToAnyEffect()
    }
}
