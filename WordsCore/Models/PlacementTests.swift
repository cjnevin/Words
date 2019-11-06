//
//  PlacementTests.swift
//  wordsTests
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import XCTest
@testable import WordsCore

class PlacementTests: XCTestCase {
    func testNoPlacementReturnedIfBoardsAreEmpty() {
        let empty = Board(spots: .empty(rows: 3, columns: 3))
        let placement = CompoundPlacement(oldBoard: empty, newBoard: empty)
        XCTAssertEqual(placement.mainPlacement.spots.alignment, .none)
        XCTAssertTrue(placement.horizontalIntersections.isEmpty)
        XCTAssertTrue(placement.verticalIntersections.isEmpty)
    }

    func testNoPlacementReturnedIfNewBoardIsIdentical() {
        let board = Board(spots: [
            .empty(row: 0, columns: 3),
            .filled(row: 1, tiles: [.a, .b, .c]),
            .empty(row: 2, columns: 3)
        ])
        let placement = CompoundPlacement(oldBoard: board, newBoard: board)
        XCTAssertEqual(placement.mainPlacement.spots.alignment, .none)
        XCTAssertTrue(placement.horizontalIntersections.isEmpty)
        XCTAssertTrue(placement.verticalIntersections.isEmpty)
    }

    func testIsHorizontalIfNewBoardHasFilledRow() {
        let oldBoard = Board(spots: .empty(rows: 3, columns: 3))
        let newBoard = Board(spots: [
            .empty(row: 0, columns: 3),
            .filled(row: 1, tiles: [.a, .b, .c]),
            .empty(row: 2, columns: 3)
        ])
        let placement = CompoundPlacement(oldBoard: oldBoard, newBoard: newBoard)
        XCTAssertEqual(placement.mainPlacement.spots.alignment, .horizontal)
        XCTAssertTrue(placement.horizontalIntersections.isEmpty)
        XCTAssertTrue(placement.verticalIntersections.isEmpty)
    }

    func testIsVerticalIfNewBoardHasFilledColumn() {
        let oldBoard = Board(spots: .empty(rows: 3, columns: 3))
        let newBoard = Board(spots: [
            .empty(row: 0, columns: 2) + [.tile(.a, at: 0, 2)],
            .empty(row: 1, columns: 2) + [.tile(.b, at: 1, 2)],
            .empty(row: 2, columns: 2) + [.tile(.c, at: 2, 2)]
        ])
        let placement = CompoundPlacement(oldBoard: oldBoard, newBoard: newBoard)
        XCTAssertEqual(placement.mainPlacement.spots.alignment, .vertical)
        XCTAssertTrue(placement.horizontalIntersections.isEmpty)
        XCTAssertTrue(placement.verticalIntersections.isEmpty)
    }

    func testIsHorizontalIfFilledRow() {
        let oldBoard = Board(spots: [
            .empty(row: 0, columns: 3),
            [.tile(.a, at: 1, 0), .empty(1, 1), .tile(.c, at: 1, 2)],
            .empty(row: 2, columns: 3)
        ])
        let newBoard = Board(spots: [
            .empty(row: 0, columns: 3),
            [.empty(1, 0), .tile(.b, at: 1, 1), .empty(1, 2)],
            .empty(row: 2, columns: 3)
        ])
        let placement = CompoundPlacement(oldBoard: oldBoard, newBoard: newBoard)
        XCTAssertEqual(placement.mainPlacement.spots.alignment, .horizontal)
        XCTAssertTrue(placement.horizontalIntersections.isEmpty)
        XCTAssertTrue(placement.verticalIntersections.isEmpty)
    }

    func testIsVerticalIfFilledColumn() {
        let oldBoard = Board(spots: [
            .empty(row: 0, columns: 2) + [.tile(.a, at: 0, 2)],
            .empty(row: 1, columns: 3),
            .empty(row: 2, columns: 2) + [.tile(.c, at: 2, 2)]
        ])
        let newBoard = Board(spots: [
            .empty(row: 0, columns: 3),
            .empty(row: 1, columns: 2) + [.tile(.b, at: 1, 2)],
            .empty(row: 2, columns: 3)
        ])
        let placement = CompoundPlacement(oldBoard: oldBoard, newBoard: newBoard)
        XCTAssertEqual(placement.mainPlacement.spots.alignment, .vertical)
        XCTAssertTrue(placement.horizontalIntersections.isEmpty)
        XCTAssertTrue(placement.verticalIntersections.isEmpty)
    }

    func testAdjacentColumnIfNewlyFilledRow() {
        let oldBoard = Board(spots: [
            .empty(row: 0, columns: 2) + [.tile(.a, at: 0, 2)],
            .empty(row: 1, columns: 3),
            .empty(row: 2, columns: 2) + [.tile(.c, at: 2, 2)]
        ])
        let newBoard = Board(spots: [
            .empty(row: 0, columns: 3),
            [.tile(.d, at: 1, 0), .tile(.e, at: 1, 1), .tile(.b, at: 1, 2)],
            .empty(row: 2, columns: 3)
        ])
        let placement = CompoundPlacement(oldBoard: oldBoard, newBoard: newBoard)
        XCTAssertEqual(placement.mainPlacement.spots.alignment, .horizontal)
        XCTAssertTrue(placement.horizontalIntersections.isEmpty)
        XCTAssertFalse(placement.verticalIntersections.isEmpty)
        XCTAssertEqual(placement.verticalFaces, ["ABC"])
    }

    func testAdjacentRowIfNewlyFilledColumn() {
        let oldBoard = Board(spots: [
            .empty(row: 0, columns: 3),
            [.tile(.d, at: 1, 0), .tile(.e, at: 1, 1), .empty(1, 2)],
            .empty(row: 2, columns: 3)
        ])
        let newBoard = Board(spots: [
            .empty(row: 0, columns: 2) + [.tile(.a, at: 0, 2)],
            .empty(row: 1, columns: 2) + [.tile(.b, at: 1, 2)],
            .empty(row: 2, columns: 2) + [.tile(.c, at: 2, 2)]
        ])
        let placement = CompoundPlacement(oldBoard: oldBoard, newBoard: newBoard)
        XCTAssertEqual(placement.mainPlacement.spots.alignment, .vertical)
        XCTAssertTrue(placement.verticalIntersections.isEmpty)
        XCTAssertFalse(placement.horizontalIntersections.isEmpty)
        XCTAssertEqual(placement.horizontalFaces, ["DEB"])
    }

    func testAdjacentColumnsIfNewlyFilledRow() {
        let oldBoard = Board(spots: [
            [.tile(.a, at: 0, 0), .tile(.d, at: 0, 1), .tile(.g, at: 0, 2)],
            .empty(row: 1, columns: 3),
            [.tile(.c, at: 2, 0), .tile(.f, at: 2, 1), .tile(.i, at: 2, 2)]
        ])
        let newBoard = Board(spots: [
            .empty(row: 0, columns: 3),
            [.tile(.b, at: 1, 0), .tile(.e, at: 1, 1), .tile(.h, at: 1, 2)],
            .empty(row: 2, columns: 3)
        ])
        let placement = CompoundPlacement(oldBoard: oldBoard, newBoard: newBoard)
        XCTAssertEqual(placement.mainPlacement.spots.alignment, .horizontal)
        XCTAssertTrue(placement.horizontalIntersections.isEmpty)
        XCTAssertFalse(placement.verticalIntersections.isEmpty)
        XCTAssertEqual(placement.verticalFaces.sorted(), ["ABC", "DEF", "GHI"])
    }

    func testAdjacentRowsIfNewlyFilledColumn() {
        let oldBoard = Board(spots: [
            [.tile(.a, at: 0, 0), .tile(.b, at: 0, 1), .empty(0, 2)],
            [.tile(.d, at: 1, 0), .tile(.e, at: 1, 1), .empty(1, 2)],
            [.tile(.g, at: 2, 0), .tile(.h, at: 2, 1), .empty(2, 2)]
        ])
        let newBoard = Board(spots: [
            .empty(row: 0, columns: 2) + [.tile(.c, at: 0, 2)],
            .empty(row: 1, columns: 2) + [.tile(.f, at: 1, 2)],
            .empty(row: 2, columns: 2) + [.tile(.i, at: 2, 2)]
        ])
        let placement = CompoundPlacement(oldBoard: oldBoard, newBoard: newBoard)
        XCTAssertEqual(placement.mainPlacement.spots.alignment, .vertical)
        XCTAssertTrue(placement.verticalIntersections.isEmpty)
        XCTAssertFalse(placement.horizontalIntersections.isEmpty)
        XCTAssertEqual(placement.horizontalFaces.sorted(), ["ABC", "DEF", "GHI"])
    }

    func testAdjacentRowsAreSkippedIfThereIsAGapBeforeNewlyFilledColumn() {
        let oldBoard = Board(spots: [
            [.tile(.a, at: 0, 0), .tile(.b, at: 0, 1), .empty(0, 2)],
            [.tile(.d, at: 1, 0), .empty(1, 1), .empty(1, 2)],
            [.tile(.g, at: 2, 0), .tile(.h, at: 2, 1), .empty(2, 2)]
        ])
        let newBoard = Board(spots: [
            .empty(row: 0, columns: 2) + [.tile(.c, at: 0, 2)],
            .empty(row: 1, columns: 2) + [.tile(.f, at: 1, 2)],
            .empty(row: 2, columns: 2) + [.tile(.i, at: 2, 2)]
        ])
        let placement = CompoundPlacement(oldBoard: oldBoard, newBoard: newBoard)
        XCTAssertEqual(placement.mainPlacement.spots.alignment, .vertical)
        XCTAssertTrue(placement.verticalIntersections.isEmpty)
        XCTAssertFalse(placement.horizontalIntersections.isEmpty)
        XCTAssertEqual(placement.horizontalFaces.sorted(), ["ABC", "GHI"])
    }

    func testAdjacentColumnsAreSkippedIfThereIsAGapBeforeNewlyFilledRow() {
        let oldBoard = Board(spots: [
            [.tile(.a, at: 0, 0), .tile(.d, at: 0, 1), .tile(.g, at: 0, 2)],
            [.tile(.b, at: 1, 0), .empty(1, 1), .tile(.h, at: 1, 2)],
            .empty(row: 2, columns: 3)
        ])
        let newBoard = Board(spots: [
            .empty(row: 0, columns: 3),
            .empty(row: 1, columns: 3),
            [.tile(.c, at: 2, 0), .tile(.f, at: 2, 1), .tile(.i, at: 2, 2)]
        ])
        let placement = CompoundPlacement(oldBoard: oldBoard, newBoard: newBoard)
        XCTAssertEqual(placement.mainPlacement.spots.alignment, .horizontal)
        XCTAssertTrue(placement.horizontalIntersections.isEmpty)
        XCTAssertFalse(placement.verticalIntersections.isEmpty)
        XCTAssertEqual(placement.verticalFaces.sorted(), ["ABC", "GHI"])
    }

    func testHorizontalEmptyCandidateResultsInInvalidPlacement() {
        let board = Board(spots: .empty(rows: 3, columns: 3))
        let placement = Placement(horizontal: [.empty(1, 1)], vertical: [])
        placement
            .candidates(on: board)
            .expectInvalidPlacement(at: placement)
    }

    func testHorizontalFilledCandidateResultsInValidPlacement() {
        let board = Board(spots: [
            .empty(row: 0, columns: 3),
            .filled(row: 1, tiles: [.a, .b, .c]),
            .empty(row: 2, columns: 3)
        ])
        let placement = Placement(horizontal: [.empty(1, 1)], vertical: [])
        placement
            .candidates(on: board)
            .expectTiles([.b])
    }

    func testVerticalEmptyCandidateResultsInInvalidPlacement() {
        let board = Board(spots: .empty(rows: 3, columns: 3))
        let placement = Placement(horizontal: [], vertical: [.empty(1, 1)])
        placement
            .candidates(on: board)
            .expectInvalidPlacement(at: placement)
    }

    func testVerticalFilledCandidateResultsInValidPlacement() {
        let board = Board(spots: [
            .empty(row: 0, columns: 3),
            .filled(row: 1, tiles: [.a, .b, .c]),
            .empty(row: 2, columns: 3)
        ])
        let placement = Placement(horizontal: [], vertical: [.empty(1, 1)])
        placement
            .candidates(on: board)
            .expectTiles([.b])
    }

    func testBidirectionalEmptyCandidateResultsInInvalidPlacement() {
        let board = Board(spots: .empty(rows: 3, columns: 3))
        let placement = Placement(horizontal: [.empty(1, 1)], vertical: [.empty(1, 1)])
        placement
            .candidates(on: board)
            .expectInvalidPlacement(at: placement)
    }

    func testBidirectionalFilledCandidateResultsInValidPlacement() {
        let board = Board(spots: [
            .empty(row: 0, columns: 3),
            .filled(row: 1, tiles: [.a, .b, .c]),
            .empty(row: 2, columns: 3)
        ])
        let placement = Placement(horizontal: [.empty(1, 1)], vertical: [.empty(1, 1)])
        placement
            .candidates(on: board)
            .expectTiles([.b, .b])
    }
}
