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
        case let placeTile as RackAction.Place:
            guard var player = state.currentPlayer else {
                preconditionFailure("No current player.")
            }
            guard let heldTile = state.turn.heldTile else {
                return .none
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
            state.turn.placementError = nil
            return .validate(state: state)

        case is RackAction.Drop:
            precondition(state.turn.heldTile != nil)
            state.turn.heldTile = nil
            return .validate(state: state)

        case let pickUpTile as RackAction.PickUp:
            guard let player = state.currentPlayer else {
                preconditionFailure("No current player.")
            }
            precondition(player.tiles.contains(pickUpTile.tile), "Player is not holding this tile.")
            state.turn.heldTile = pickUpTile.tile
            state.turn.placementError = nil

        case let returnTile as RackAction.Return:
            guard var player = state.currentPlayer else {
                preconditionFailure("No current player.")
            }
            guard let tile = returnTile.spot.tile else {
                preconditionFailure("Return tile should not be null.")
            }
            guard tile.movable else {
                return .none
            }
            var spot = returnTile.spot
            spot.tile = nil
            state.turn.board.spots[returnTile.spot.row][returnTile.spot.column] = spot
            state.turn.placementError = nil
            player.tiles.append(tile)
            state.currentPlayer = player
            return .validate(state: state)

        case is RackAction.ReturnAll:
            state.restoreRack()
            state.turn.board = state.board
            state.turn.placementError = nil
            return .validate(state: state)

        case is RackAction.Shuffle:
            state.currentPlayer?.shuffle()

        case is RackAction.Exchange.Begin:
            state.turn.isExchanging = true

        case let toggle as RackAction.Exchange.Toggle:
            precondition(state.turn.isExchanging, "You must be exchanging to call this action.")
            if let index = state.turn.exchangingTiles.firstIndex(of: toggle.tile) {
                state.turn.exchangingTiles.remove(at: index)
            } else {
                state.turn.exchangingTiles.append(toggle.tile)
            }

        case is RackAction.Exchange.End:
            precondition(state.turn.isExchanging, "You must be exchanging to call this action.")
            guard var player = state.currentPlayer else {
                preconditionFailure("No current player.")
            }
            if state.turn.exchangingTiles.isEmpty {
                state.turn.isExchanging = false
            } else {
                state.tileBag.tiles += state.turn.exchangingTiles
                var copy = state
                player.swap(tiles: state.turn.exchangingTiles, replenish: { copy.tileBag.takeOne() })
                copy.currentPlayer = player
                state = copy
                state.nextPlayer()
                return .validate(state: state)
            }

        case is RackAction.Exchange.Cancel:
            state.turn.isExchanging = false
            state.turn.exchangingTiles = []

        case let incorrect as ValidationAction.Incorrect:
            state.update(candidates: incorrect.candidates, status: .invalid)
            state.turn.words = []
            state.turn.placementError = nil
            state.turn.score = 0

        case let invalid as ValidationAction.Invalid:
            state.update(candidates: [], status: .default)
            state.turn.words = []
            state.turn.placementError = invalid.error
            state.turn.score = 0

        case let valid as ValidationAction.Valid:
            state.update(candidates: valid.candidates, status: .valid)
            state.turn.words = valid.candidates.words
            state.turn.score = valid.score
            state.turn.placementError = nil

        case is TurnAction.Submit:
            guard var player = state.currentPlayer else {
                preconditionFailure("No current player.")
            }
            precondition(state.turn.canSubmit, "Submission not possible.")
            player.score += state.turn.score
            state.tileBag.replenish(player: &player)
            state.currentPlayer = player
            state.update(candidates: [], status: .default)
            state.board = state.turn.board
            state.board.lock()
            state.nextPlayer()

        case is TurnAction.Skip:
            precondition(state.currentPlayer != nil, "No current player.")
            state.restoreRack()
            state.nextPlayer()

        case let newGame as TurnAction.NewGame:
            var tileBag = TileBag(distribution: newGame.tileDistribution)
            let players = newGame.players.map { name -> Player in
                let tiles = (0..<tileBag.rack).compactMap { _ in tileBag.takeOne() }
                return Player(name: name, tiles: tiles, score: 0)
            }
            let board = Board(layout: newGame.layout)
            state = GameState(
                board: board,
                players: players,
                playerIndex: 0,
                tileBag: tileBag,
                turn: .init(board: board))

        default:
            break
        }
        return .none
    }
}

extension GameState {
    mutating func update(candidates: [Candidate], status: Spot.Status) {
        turn.board.spots = turn.board.spots.map { row in
            row.map { column in
                var copy = column
                if candidates.spots.contains(where: { $0.sameAs(column) }) {
                    copy.status = status
                } else {
                    copy.status = .default
                }
                return copy
            }
        }
    }
}
