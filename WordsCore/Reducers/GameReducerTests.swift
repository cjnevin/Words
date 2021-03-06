//
//  GameReducerTests.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import XCTest
import Redux
@testable import WordsCore

extension GameStore {
    static func with(state: GameState) -> GameStore {
        GameStore(initialState: state, reducer: GameReducer(), dependencies: GameDependencies.mocked, effectQueue: .main)
    }
}

class GameReducerTests: XCTestCase {
    func testNewGameIsSetupCorrectly() {
        let distribution: TileBag.Distribution = .init(elements: [
            .init(face: "A", value: 1, amount: 7),
            .init(face: "B", value: 3, amount: 7),
            .init(face: "C", value: 3, amount: 7)
        ], rack: 7)
        let action = TurnAction.NewGame(
            players: ["Player1", "Player2"],
            layout: Board.defaultLayout,
            tileDistribution: distribution)
        let store = GameStore.with(state: GameState())
        store.send(action)
        XCTAssertEqual(store.state.tileBag.tiles.count, 7, "7 tiles should remain")
        XCTAssertEqual(store.state.players.first?.tiles.count, 7, "Player 1 should have 7 tiles")
        XCTAssertEqual(store.state.players.first?.name, "Player1")
        XCTAssertEqual(store.state.players.last?.tiles.count, 7, "Player 2 should have 7 tiles")
        XCTAssertEqual(store.state.players.last?.name, "Player2")
        XCTAssertEqual(store.state.board.spots.count, 15, "Board is incorrect size")
        XCTAssertEqual(store.state.board, store.state.turn.board)
    }
    
    func testSwapTilesReturnsDifferentTiles() {
        let swappingPlayer = Player(name: "Player 1", tiles: [.a, .b, .c, .d, .e, .f, .g])
        let nextPlayer = Player(name: "Player 2", tiles: [.h, .i])
        let begin = RackAction.Exchange.Begin()
        let toggleA = RackAction.Exchange.Toggle(tile: .a)
        let toggleB = RackAction.Exchange.Toggle(tile: .b)
        let toggleC = RackAction.Exchange.Toggle(tile: .c)
        let end = RackAction.Exchange.End()
        let initialState = GameState(
            players: [swappingPlayer, nextPlayer],
            tileBag: TileBag(tiles: [.d, .e, .f])
        )
        let store = GameStore.with(state: initialState)
        // This loop ensures we get random tiles that don't match our existing ones.
        var matching: Bool = true
        while matching {
            store.send(begin)
            store.send(toggleA)
            store.send(toggleB)
            store.send(toggleC)
            store.send(end)
            XCTAssertEqual(store.state.currentPlayer, nextPlayer)
            store.send(TurnAction.Skip())
            XCTAssertEqual(store.state.playerIndex, 0)
            matching = store.state.tileBag.tiles == initialState.tileBag.tiles
                && store.state.currentPlayer?.tiles == initialState.currentPlayer?.tiles
        }
        XCTAssertEqual(store.state.playerIndex, 0)
        XCTAssertEqual(store.state.tileBag.tiles.count,
                       initialState.tileBag.tiles.count)
        XCTAssertEqual(store.state.currentPlayer?.tiles.count,
                       initialState.currentPlayer?.tiles.count)
    }

    func testDropClearsHeldTile() {
        let initialState = GameState(players: [.init(name: "Player 1", tiles: [.a], score: 0)], turn: .init(heldTile: .a))
        let store = GameStore.with(state: initialState)
        XCTAssertEqual(store.state.turn.heldTile, .a)
        store.send(RackAction.Drop())
        XCTAssertNil(store.state.turn.heldTile)
    }

    func testPickUpSetsHeldTile() {
        let initialState = GameState(players: [.init(name: "Player 1", tiles: [.a], score: 0)])
        let action = RackAction.PickUp(tile: .a)
        let store = GameStore.with(state: initialState)
        store.send(action)
        XCTAssertEqual(store.state.turn.heldTile, .a)
    }

    func testPlaceAtOccupiedSpot() {
        let oldSpot = Spot.tile(.a, at: 1, 2)
        let oldBoard = Board(spots: [
            .empty(row: 0, columns: 3),
            .empty(row: 1, columns: 2) + [oldSpot],
            .empty(row: 2, columns: 3)
        ])
        let action = RackAction.Place(at: oldSpot)
        let initialState = GameState(board: oldBoard, players: [.init(name: "Player 1", tiles: [.b])], turn: .init(board: oldBoard, heldTile: .b))
        let store = GameStore.with(state: initialState)
        store.send(action)
        XCTAssertEqual(store.state.turn.board, store.state.board)
        XCTAssertEqual(store.state.currentPlayer?.tiles, [.b])
        XCTAssertNil(store.state.turn.heldTile)
    }

    func testPlaceAtFreeSpot() {
        let oldBoard = Board(spots: .empty(rows: 3, columns: 3))
        let action = RackAction.Place(at: .empty(1, 1))
        let initialState = GameState(board: oldBoard, players: [.init(name: "Player 1", tiles: [.a])], turn: .init(board: oldBoard, heldTile: .a))
        let store = GameStore.with(state: initialState)
        store.send(action)
        XCTAssertNotEqual(store.state.turn.board, store.state.board)
        XCTAssertEqual(store.state.turn.board.spots[1][1].tile, Tile.a)
        XCTAssertNil(store.state.turn.heldTile)
        XCTAssertTrue(store.state.currentPlayer!.tiles.isEmpty)
    }

    func testReturnTileUpdatesBoard() {
        let oldBoard = Board(spots: .empty(rows: 3, columns: 3))
        let newBoard = Board(spots: [
            .empty(row: 0, columns: 3),
            .empty(row: 1, columns: 2) + [.tile(.a, at: 1, 2)],
            .empty(row: 2, columns: 3)
        ])
        let spot = Spot(row: 1, column: 2, middle: false, multiplier: 1, wordMultiplier: 1, tile: .a)
        let action = RackAction.Return(from: spot)
        let initialState = GameState(board: oldBoard, players: [.init(name: "Player 1")], turn: .init(board: newBoard))
        let store = GameStore.with(state: initialState)
        store.send(action)
        XCTAssertEqual(store.state.turn.board, store.state.board)
    }

    func testReturnTilesToRackResetsBoardAndPlacement() {
        let oldBoard = Board(spots: .empty(rows: 3, columns: 3))
        let newBoard = Board(spots: [
            .empty(row: 0, columns: 3),
            .filled(row: 1, tiles: [.a, .b, .c]),
            .empty(row: 2, columns: 3)
        ])
        let initialState = GameState(board: oldBoard, players: [.init(name: "Player 1")], turn: .init(board: newBoard))
        let action = RackAction.ReturnAll()
        let store = GameStore.with(state: initialState)
        store.send(action)
        XCTAssertEqual(store.state.turn.board, store.state.board)
        XCTAssertEqual(store.state.currentPlayer!.tiles, [.a, .b, .c])
    }

    func testTilesAreShuffled() {
        let player = Player(name: "Player 1", tiles: [.a, .b, .c, .d, .e, .f, .g], score: 0)
        let initialState = GameState(players: [player])
        let store = GameStore.with(state: initialState)
        let action = RackAction.Shuffle()
        var equal = true
        while equal {
            store.send(action)
            equal = store.state.currentPlayer?.tiles == initialState.currentPlayer?.tiles
        }
        XCTAssertEqual(store.state.currentPlayer?.tiles.count, player.tiles.count)
        XCTAssertNotEqual(store.state.currentPlayer?.tiles, initialState.currentPlayer?.tiles)
    }

    func testValidClearsPlacementError() {
        let turn = GameState.Turn(placementError: .tileMisaligned)
        let store = GameStore.with(state: .init(turn: turn))
        let candidate = Candidate(spots: [.tile(.a, at: 1, 1)], tiles: [.a])!
        store.send(ValidationAction.Valid(score: 1, candidates: [candidate]))
        XCTAssertNil(store.state.turn.placementError)
        XCTAssertEqual(store.state.turn.score, 1)
        XCTAssertFalse(store.state.turn.validCandidates.isEmpty)
        XCTAssertTrue(store.state.turn.invalidCandidates.isEmpty)
    }

    func testIncorrectClearsValidPlacements() {
        let turn = GameState.Turn(placementError: .tileMisaligned)
        let store = GameStore.with(state: .init(turn: turn))
        let candidate = Candidate(spots: [.tile(.a, at: 1, 1)], tiles: [.a])!
        store.send(ValidationAction.Valid(score: 1, candidates: [candidate]))
        store.send(ValidationAction.Incorrect(candidates: [candidate]))
        XCTAssertNil(store.state.turn.placementError)
        XCTAssertEqual(store.state.turn.score, 0)
        XCTAssertTrue(store.state.turn.validCandidates.isEmpty)
        XCTAssertFalse(store.state.turn.invalidCandidates.isEmpty)
    }

    func testInvalidClearsValidAndMisplaced() {
        let store = GameStore.with(state: .init())
        let candidate = Candidate(spots: [.tile(.a, at: 1, 1)], tiles: [.a])!
        PlacementError.allCases.forEach { error in
            store.send(ValidationAction.Valid(score: 100, candidates: [candidate]))
            store.send(ValidationAction.Invalid(error: error))
            XCTAssertTrue(store.state.turn.validCandidates.isEmpty)
            XCTAssertTrue(store.state.turn.invalidCandidates.isEmpty)
            XCTAssertEqual(store.state.turn.score, 0)
            XCTAssertEqual(store.state.turn.placementError, error)
        }
    }

    func testSkipGoesToNextPlayer() {
        let a = Player(name: "Player 1", tiles: [.a])
        let b = Player(name: "Player 2", tiles: [.b])
        let initialState = GameState(players: [a, b])
        let store = GameStore.with(state: initialState)
        [a, b, a].forEach {
            XCTAssertEqual(store.state.currentPlayer, $0)
            store.send(TurnAction.Skip())
        }
        XCTAssertEqual(store.state.board, store.state.turn.board)
    }

    func testSkipRestoresTilesBeforeSkipping() {
        let oldBoard = Board(spots: .empty(rows: 3, columns: 3))
        let newBoard = Board(spots: [
            .empty(row: 0, columns: 3),
            .filled(row: 1, tiles: [.a, .b, .c]),
            .empty(row: 2, columns: 3)
        ])
        let a = Player(name: "Player 1", tiles: [])
        let b = Player(name: "Player 2", tiles: [.b])
        let initialState = GameState(board: oldBoard, players: [a, b], turn: .init(board: newBoard))
        let store = GameStore.with(state: initialState)
        XCTAssertEqual(store.state.currentPlayer, a)
        XCTAssertTrue(store.state.currentPlayer!.tiles.isEmpty)
        store.send(TurnAction.Skip())
        XCTAssertEqual(store.state.currentPlayer, b)
        store.send(TurnAction.Skip())
        XCTAssertEqual(store.state.currentPlayer!.name, a.name)
        XCTAssertEqual(store.state.currentPlayer!.tiles, [.a, .b, .c])
        XCTAssertEqual(store.state.board, store.state.turn.board)
    }

    func testSubmitLocksBoardAppliesScoreAndMovesToNextPlayer() {
        let oldBoard = Board(pattern: """
            -|-|-
            -|-|-
            -|-|-
        """)
        let newBoard = Board(pattern: """
            -|-|-
            A|B|C
            -|-|-
        """)
        let a = Player(name: "Player 1", tiles: [])
        let b = Player(name: "Player 2", tiles: [.b])
        let candidate = Candidate(spots: [.tile(.a, at: 1, 1)], tiles: [.a])!
        let initialState = GameState(board: oldBoard, players: [a, b], turn: .init(board: newBoard))
        let store = GameStore.with(state: initialState)
        store.send(ValidationAction.Valid(score: 10, candidates: [candidate]))
        store.send(TurnAction.Submit())
        XCTAssertTrue(store.state.board.isLocked)
        XCTAssertEqual(store.state.currentPlayer, b)
        XCTAssertEqual(store.state.players.first?.score, 10)
    }
}

extension Tile {
    static let a: Tile = Tile(id: "A0", face: "A", value: 1, movable: true)
    static let b: Tile = Tile(id: "B0", face: "B", value: 3, movable: true)
    static let c: Tile = Tile(id: "C0", face: "C", value: 3, movable: true)
    static let d: Tile = Tile(id: "D0", face: "D", value: 2, movable: true)
    static let e: Tile = Tile(id: "E0", face: "E", value: 1, movable: true)
    static let f: Tile = Tile(id: "F0", face: "F", value: 4, movable: true)
    static let g: Tile = Tile(id: "G0", face: "G", value: 2, movable: true)
    static let h: Tile = Tile(id: "H0", face: "H", value: 4, movable: true)
    static let i: Tile = Tile(id: "I0", face: "I", value: 1, movable: true)
    static let j: Tile = Tile(id: "J0", face: "J", value: 8, movable: true)
}
