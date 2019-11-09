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
        let result = empty.calculatePlacement(comparingWith: empty)
        switch result {
        case .failure(.tileNotPlaced): break
        default: XCTFail("Expected tileNotPlaced")
        }
    }

    func testNoPlacementReturnedIfNewBoardIsIdentical() {
        let board = Board(pattern: """
            -|-|-
            A|B|C
            -|-|-
        """)
        let result = board.calculatePlacement(comparingWith: board)
        switch result {
        case .failure(.tileNotPlaced): break
        default: XCTFail("Expected tileNotPlaced")
        }
    }

    func testIsHorizontalIfNewBoardHasFilledRow() {
        let oldBoard = Board(spots: .empty(rows: 3, columns: 3))
        let newBoard = Board(pattern: """
            -|-|-
            A|B|C
            -|-|-
        """)
        let result = oldBoard.calculatePlacement(comparingWith: newBoard)
        switch result {
        case let .success(placement):
            XCTAssertEqual(placement.mainPlacement.spots.alignment, .horizontal)
            XCTAssertTrue(placement.horizontalIntersections.isEmpty)
            XCTAssertTrue(placement.verticalIntersections.isEmpty)
        default: XCTFail("Expected success")
        }
    }

    func testIsVerticalIfNewBoardHasFilledColumn() {
        let oldBoard = Board(spots: .empty(rows: 3, columns: 3))
        let newBoard = Board(pattern: """
            -|A|-
            -|B|-
            -|C|-
        """)
        let result = oldBoard.calculatePlacement(comparingWith: newBoard)
        switch result {
        case let .success(placement):
            XCTAssertEqual(placement.mainPlacement.spots.alignment, .vertical)
            XCTAssertTrue(placement.horizontalIntersections.isEmpty)
            XCTAssertTrue(placement.verticalIntersections.isEmpty)
        default: XCTFail("Expected success")
        }
    }

    func testIsHorizontalIfFilledRow() {
        let oldBoard = Board(pattern: """
            -|-|-
            A|-|C
            -|-|-
        """)
        let newBoard = Board(pattern: """
            -|-|-
            -|B|-
            -|-|-
        """)
        let result = oldBoard.calculatePlacement(comparingWith: newBoard)
        switch result {
        case let .success(placement):
            XCTAssertEqual(placement.mainPlacement.spots.alignment, .horizontal)
            XCTAssertTrue(placement.horizontalIntersections.isEmpty)
            XCTAssertTrue(placement.verticalIntersections.isEmpty)
        default: XCTFail("Expected success")
        }
    }

    func testIsVerticalIfFilledColumn() {
        let oldBoard = Board(pattern: """
            -|A|-
            -|-|-
            -|C|-
        """)
        let newBoard = Board(pattern: """
            -|-|-
            -|B|-
            -|-|-
        """)
        let result = oldBoard.calculatePlacement(comparingWith: newBoard)
        switch result {
        case let .success(placement):
            XCTAssertEqual(placement.mainPlacement.spots.alignment, .vertical)
            XCTAssertTrue(placement.horizontalIntersections.isEmpty)
            XCTAssertTrue(placement.verticalIntersections.isEmpty)
        default: XCTFail("Expected success")
        }
    }

    func testAdjacentColumnIfNewlyFilledRow() {
        let oldBoard = Board(pattern: """
            -|A|-
            -|-|-
            -|C|-
        """)
        let newBoard = Board(pattern: """
            -|-|-
            D|B|E
            -|-|-
        """)
        let result = oldBoard.calculatePlacement(comparingWith: newBoard)
        switch result {
        case let .success(placement):
            XCTAssertEqual(placement.mainPlacement.spots.alignment, .horizontal)
            XCTAssertTrue(placement.horizontalIntersections.isEmpty)
            XCTAssertFalse(placement.verticalIntersections.isEmpty)
            XCTAssertEqual(placement.verticalFaces, ["ABC"])
            XCTAssertEqual(placement.mainFaces, "DBE")
        default: XCTFail("Expected success")
        }
    }

    func testAdjacentRowIfNewlyFilledColumn() {
        let oldBoard = Board(pattern: """
            -|-|-
            A|-|C
            -|-|-
        """)
        let newBoard = Board(pattern: """
            -|D|-
            -|B|-
            -|E|-
        """)
        let result = oldBoard.calculatePlacement(comparingWith: newBoard)
        switch result {
        case let .success(placement):
            XCTAssertEqual(placement.mainPlacement.spots.alignment, .vertical)
            XCTAssertTrue(placement.verticalIntersections.isEmpty)
            XCTAssertFalse(placement.horizontalIntersections.isEmpty)
            XCTAssertEqual(placement.horizontalFaces, ["ABC"])
            XCTAssertEqual(placement.mainFaces, "DBE")
        default: XCTFail("Expected success")
        }
    }

    func testAdjacentColumnsIfNewlyFilledRow() {
        let oldBoard = Board(pattern: """
            A|D|G
            -|-|-
            C|F|I
        """)
        let newBoard = Board(pattern: """
            -|-|-
            B|E|H
            -|-|-
        """)
        let result = oldBoard.calculatePlacement(comparingWith: newBoard)
        switch result {
        case let .success(placement):
            XCTAssertEqual(placement.mainPlacement.spots.alignment, .horizontal)
            XCTAssertFalse(placement.verticalIntersections.isEmpty)
            XCTAssertTrue(placement.horizontalIntersections.isEmpty)
            XCTAssertEqual(placement.verticalFaces.sorted(), ["ABC", "DEF", "GHI"])
            XCTAssertEqual(placement.mainFaces, "BEH")
        default: XCTFail("Expected success")
        }
    }

    func testAdjacentRowsIfNewlyFilledColumn() {
        let oldBoard = Board(pattern: """
            A|B|-
            D|E|-
            G|H|-
        """)
        let newBoard = Board(pattern: """
            -|-|C
            -|-|F
            -|-|I
        """)
        let result = oldBoard.calculatePlacement(comparingWith: newBoard)
        switch result {
        case let .success(placement):
            XCTAssertEqual(placement.mainPlacement.spots.alignment, .vertical)
            XCTAssertTrue(placement.verticalIntersections.isEmpty)
            XCTAssertFalse(placement.horizontalIntersections.isEmpty)
            XCTAssertEqual(placement.horizontalFaces.sorted(), ["ABC", "DEF", "GHI"])
            XCTAssertEqual(placement.mainFaces, "CFI")
        default: XCTFail("Expected success")
        }
    }

    func testAdjacentRowsAreSkippedIfThereIsAGapBeforeNewlyFilledColumn() {
        let oldBoard = Board(pattern: """
            A|B|-
            D|E|-
            G|-|-
        """)
        let newBoard = Board(pattern: """
            -|-|C
            -|-|F
            -|-|I
        """)
        let result = oldBoard.calculatePlacement(comparingWith: newBoard)
        switch result {
        case let .success(placement):
            XCTAssertEqual(placement.mainPlacement.spots.alignment, .vertical)
            XCTAssertTrue(placement.verticalIntersections.isEmpty)
            XCTAssertFalse(placement.horizontalIntersections.isEmpty)
            XCTAssertEqual(placement.horizontalFaces.sorted(), ["ABC", "DEF"])
            XCTAssertEqual(placement.mainFaces, "CFI")
        default: XCTFail("Expected success")
        }
    }

    func testAdjacentColumnsAreSkippedIfThereIsAGapBeforeNewlyFilledRow() {
        let oldBoard = Board(pattern: """
            A|D|G
            B|E|-
            -|-|-
        """)
        let newBoard = Board(pattern: """
            -|-|-
            -|-|-
            C|F|I
        """)
        let result = oldBoard.calculatePlacement(comparingWith: newBoard)
        switch result {
        case let .success(placement):
            XCTAssertEqual(placement.mainPlacement.spots.alignment, .horizontal)
            XCTAssertFalse(placement.verticalIntersections.isEmpty)
            XCTAssertTrue(placement.horizontalIntersections.isEmpty)
            XCTAssertEqual(placement.verticalFaces.sorted(), ["ABC", "DEF"])
            XCTAssertEqual(placement.mainFaces, "CFI")
        default: XCTFail("Expected success")
        }
    }
}
