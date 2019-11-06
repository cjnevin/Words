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

class GameReducerTests: XCTestCase {
    func testCreateBagGeneratesExpectedTiles() {
        let action = BagAction.Reset(distribution: [
            3: ("A", 1),
            2: ("B", 3),
            1: ("C", 3)
        ])
        let store = Store(initialState: GameState(), reducer: gameReducer, dependencies: GameDependencies.mocked)
        store.send(action)
        let faces = store.state.tileBag.tiles.map { $0.face }.sorted()
        XCTAssertEqual(faces, ["A", "A", "A", "B", "B", "C"])
    }
    
    func testSwapTilesReturnsDifferentTiles() {
        let swappingPlayer = Player(tiles: [.a, .b, .c, .d, .e, .f, .g])
        let nextPlayer = Player(tiles: [.h, .i])
        let action = TurnAction.Exchange(tiles: [.a, .b, .c])
        let initialState = GameState(
            players: [swappingPlayer, nextPlayer],
            tileBag: TileBag(tiles: [.d, .e, .f])
        )
        let store = Store(initialState: initialState, reducer: gameReducer, dependencies: GameDependencies.mocked)
        // This loop ensures we get random tiles that don't match our existing ones.
        var matching: Bool = true
        while matching {
            store.send(action)
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

    func testPickUpSetsHeldTile() {
        let state = GameState(players: [.init(tiles: [.a], score: 0)])
        let action = RackAction.PickUp(tile: .a)
        let store = Store(initialState: state, reducer: gameReducer, dependencies: GameDependencies.mocked)
        store.send(action)
        XCTAssertEqual(store.state.turn.heldTile, .a)
        XCTAssertTrue(store.state.currentPlayer!.tiles.isEmpty)
    }

    func testPlaceAtOccupiedSpot() {
        let oldSpot = Spot.tile(.a, at: 1, 2)
        let oldBoard = Board(spots: [
            .empty(row: 0, columns: 3),
            .empty(row: 1, columns: 2) + [oldSpot],
            .empty(row: 2, columns: 3)
        ])
        let action = RackAction.Place(at: oldSpot)
        let state = GameState(board: oldBoard, players: [.init()], turn: .init(board: oldBoard, heldTile: .b))
        let store = Store(initialState: state, reducer: gameReducer, dependencies: GameDependencies.mocked)
        store.send(action)
        XCTAssertEqual(store.state.turn.board, store.state.board)
        XCTAssertEqual(store.state.currentPlayer?.tiles, [.b])
        XCTAssertNil(store.state.turn.heldTile)
        XCTAssertTrue(state.currentPlayer!.tiles.isEmpty)
    }

    func testPlaceAtFreeSpot() {
        let oldBoard = Board(spots: .empty(rows: 3, columns: 3))
        let action = RackAction.Place(at: .empty(1, 1))
        let state = GameState(board: oldBoard, players: [.init()], turn: .init(board: oldBoard, heldTile: .a))
        let store = GameStore(initialState: state, reducer: gameReducer, dependencies: GameDependencies.mocked)
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
        let initialState = GameState(board: oldBoard, turn: .init(board: newBoard))
        let store = GameStore(initialState: initialState, reducer: gameReducer, dependencies: GameDependencies.mocked)
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
        let initialState = GameState(board: oldBoard, turn: .init(board: newBoard))
        let action = RackAction.ReturnAll()
        let store = Store(initialState: initialState, reducer: gameReducer, dependencies: GameDependencies.mocked)
        store.send(action)
        XCTAssertEqual(store.state.turn.board, store.state.board)
    }

    func testTilesAreShuffled() {
        let player = Player(tiles: [.a, .b, .c, .d, .e, .f, .g], score: 0)
        let initialState = GameState(players: [player])
        let store = Store(initialState: initialState, reducer: gameReducer, dependencies: GameDependencies.mocked)
        let action = RackAction.Shuffle()
        var equal = true
        while equal {
            store.send(action)
            equal = store.state.currentPlayer?.tiles == initialState.currentPlayer?.tiles
        }
        XCTAssertEqual(store.state.currentPlayer?.tiles.count, player.tiles.count)
        XCTAssertNotEqual(store.state.currentPlayer?.tiles, initialState.currentPlayer?.tiles)
    }

    func testValidClearsInvalidAndMisplaced() {
        let candidate = Candidate(spots: [.empty(1, 1)], tiles: [.a])!
        let turn = GameState.Turn(
            misplacedSpots: [Placement(horizontal: .empty(row: 2, columns: 2), vertical: [])],
            invalidCandidates: [candidate])
        let store = GameStore(initialState: .init(turn: turn), reducer: gameReducer, dependencies: GameDependencies.mocked)
        store.send(ValidationAction.Valid(score: 1))
        XCTAssertTrue(store.state.turn.invalidCandidates.isEmpty)
        XCTAssertTrue(store.state.turn.misplacedSpots.isEmpty)
        XCTAssertEqual(store.state.turn.score, 1)
    }

    func testInvalidClearsValidAndMisplaced() {
        let candidate = Candidate(spots: [.empty(1, 1)], tiles: [.a])!
        let turn = GameState.Turn(
            misplacedSpots: [Placement(horizontal: .empty(row: 2, columns: 2), vertical: [])],
            score: 1)
        let store = GameStore(initialState: .init(turn: turn), reducer: gameReducer, dependencies: GameDependencies.mocked)
        store.send(ValidationAction.Invalid(candidates: [candidate]))
        XCTAssertEqual(store.state.turn.score, 0)
        XCTAssertTrue(store.state.turn.misplacedSpots.isEmpty)
        XCTAssertEqual(store.state.turn.invalidCandidates, [candidate])
    }

    func testMisplacedClearsValidAndInvalid() {
        let candidate = Candidate(spots: [.empty(1, 1)], tiles: [.a])!
        let placement = Placement(horizontal: .empty(row: 2, columns: 2), vertical: [])
        let turn = GameState.Turn(
            invalidCandidates: [candidate],
            score: 1)
        let store = GameStore(initialState: .init(turn: turn), reducer: gameReducer, dependencies: GameDependencies.mocked)
        store.send(ValidationAction.Misplaced(placements: [placement]))
        XCTAssertEqual(store.state.turn.score, 0)
        XCTAssertTrue(store.state.turn.invalidCandidates.isEmpty)
        XCTAssertEqual(store.state.turn.misplacedSpots, [placement])
    }

    func testSkipGoesToNextPlayer() {
        let a = Player(tiles: [.a])
        let b = Player(tiles: [.b])
        let initialState = GameState(players: [a, b])
        let store = Store(initialState: initialState, reducer: gameReducer, dependencies: GameDependencies.mocked)
        [a, b, a].forEach {
            XCTAssertEqual(store.state.currentPlayer, $0)
            store.send(TurnAction.Skip())
        }
    }
}

extension Tile {
    static let a: Tile = Tile(id: "A0", face: "A", value: 1)
    static let b: Tile = Tile(id: "B0", face: "B", value: 3)
    static let c: Tile = Tile(id: "C0", face: "C", value: 3)
    static let d: Tile = Tile(id: "D0", face: "D", value: 2)
    static let e: Tile = Tile(id: "E0", face: "E", value: 1)
    static let f: Tile = Tile(id: "F0", face: "F", value: 4)
    static let g: Tile = Tile(id: "G0", face: "G", value: 2)
    static let h: Tile = Tile(id: "H0", face: "H", value: 4)
    static let i: Tile = Tile(id: "I0", face: "I", value: 1)
    static let j: Tile = Tile(id: "J0", face: "J", value: 8)
}
