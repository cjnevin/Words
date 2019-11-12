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

    func expectAdjacentHorizontalPlays(
        horizontal: String,
        verticalFaces: [String],
        for oldBoard: Board,
        newBoard: Board,
        file: StaticString = #file,
        line: UInt = #line) {
            let result = oldBoard.calculatePlacement(comparingWith: newBoard)
            switch result {
            case let .success(placement):
                XCTAssertEqual(placement.mainPlacement.horizontal.faces, horizontal, file: file, line: line)
                XCTAssertTrue(placement.mainPlacement.vertical.faces.isEmpty, file: file, line: line)
                XCTAssertEqual(placement.verticalFaces, verticalFaces, file: file, line: line)
                XCTAssertTrue(placement.horizontalFaces.isEmpty, placement.horizontalFaces.joined(separator: ", "), file: file, line: line)
            default:
                XCTFail("Expected success", file: file, line: line)
            }
    }

    func testAdjacentHorizontalPlaysOnTopRight() {
        expectAdjacentHorizontalPlays(
            horizontal: "AB",
            verticalFaces: ["AS", "BE"],
            for: Board(pattern: """
                -|-|-|-|-|-|-
                -|-|-|C|-|-|-
                -|-|-|U|-|-|-
                -|-|-|T|-|-|-
                -|-|-|E|-|-|-
                -|-|-|R|I|S|E
                -|-|-|-|-|-|-
            """),
            newBoard: Board(pattern: """
                -|-|-|-|-|-|-
                -|-|-|C|-|-|-
                -|-|-|U|-|-|-
                -|-|-|T|-|-|-
                -|-|-|E|-|A|B
                -|-|-|R|I|S|E
                -|-|-|-|-|-|-
            """))
    }

    func testAdjacentHorizontalPlaysOnTopLeft() {
        expectAdjacentHorizontalPlays(
            horizontal: "AE",
            verticalFaces: ["AS", "ET"],
            for: Board(pattern: """
                -|-|-|-|-|-|-
                -|-|-|C|-|-|-
                -|-|-|U|-|-|-
                -|-|-|T|-|-|-
                -|-|-|E|-|-|-
                S|T|I|R|-|-|-
                -|-|-|-|-|-|-
            """),
            newBoard: Board(pattern: """
                -|-|-|-|-|-|-
                -|-|-|C|-|-|-
                -|-|-|U|-|-|-
                -|-|-|T|-|-|-
                A|E|-|E|-|-|-
                S|T|I|R|-|-|-
                -|-|-|-|-|-|-
            """))
    }

    func testAdjacentHorizontalPlaysOnBottomLeft() {
        expectAdjacentHorizontalPlays(
            horizontal: "AE",
            verticalFaces: ["TA", "HE"],
            for: Board(pattern: """
                -|-|-|-|-|-|-
                T|H|I|S|-|-|-
                -|-|-|A|-|-|-
                -|-|-|U|-|-|-
                -|-|-|T|-|-|-
                -|-|-|E|-|-|-
                -|-|-|-|-|-|-
            """),
            newBoard: Board(pattern: """
                -|-|-|-|-|-|-
                T|H|I|S|-|-|-
                A|E|-|A|-|-|-
                -|-|-|U|-|-|-
                -|-|-|T|-|-|-
                -|-|-|E|-|-|-
                -|-|-|-|-|-|-
            """))
    }

    func testAdjacentHorizontalPlaysOnBottomRight() {
        expectAdjacentHorizontalPlays(
            horizontal: "RE",
            verticalFaces: ["AR", "RE"],
            for: Board(pattern: """
                -|-|-|-|-|-|-
                -|-|-|S|T|I|R
                -|-|-|A|-|-|-
                -|-|-|U|-|-|-
                -|-|-|T|-|-|-
                -|-|-|E|-|-|-
                -|-|-|-|-|-|-
            """),
            newBoard: Board(pattern: """
                -|-|-|-|-|-|-
                -|-|-|S|T|A|R
                -|-|-|A|-|R|E
                -|-|-|U|-|-|-
                -|-|-|T|-|-|-
                -|-|-|E|-|-|-
                -|-|-|-|-|-|-
            """))
    }

    func expectAdjacentVerticalPlays(
        vertical: String,
        horizontalFaces: [String],
        for oldBoard: Board,
        newBoard: Board,
        file: StaticString = #file,
        line: UInt = #line) {
            let result = oldBoard.calculatePlacement(comparingWith: newBoard)
            switch result {
            case let .success(placement):
                XCTAssertEqual(placement.mainPlacement.vertical.faces, vertical, file: file, line: line)
                XCTAssertTrue(placement.mainPlacement.horizontal.faces.isEmpty, file: file, line: line)
                XCTAssertEqual(placement.horizontalFaces, horizontalFaces, file: file, line: line)
                XCTAssertTrue(placement.verticalFaces.isEmpty, placement.verticalFaces.joined(separator: ", "), file: file, line: line)
            default:
                XCTFail("Expected success", file: file, line: line)
            }
    }

    func testAdjacentVerticalPlaysOnTopRight() {
        expectAdjacentVerticalPlays(
            vertical: "AB",
            horizontalFaces: ["AS", "BE"],
            for: Board(pattern: """
                -|-|-|-|-|-|-
                -|-|-|-|-|-|-
                -|-|-|-|-|-|-
                -|C|U|T|E|R|-
                -|-|-|-|-|I|-
                -|-|-|-|-|S|-
                -|-|-|-|-|E|-
            """),
            newBoard: Board(pattern: """
                -|-|-|-|-|-|-
                -|-|-|-|-|-|-
                -|-|-|-|-|-|-
                -|C|U|T|E|R|-
                -|-|-|-|-|I|-
                -|-|-|-|A|S|-
                -|-|-|-|B|E|-
            """))
    }

    func testAdjacentVerticalPlaysOnTopLeft() {
        expectAdjacentVerticalPlays(
            vertical: "AE",
            horizontalFaces: ["AS", "ET"],
            for: Board(pattern: """
                -|-|-|-|-|S|-
                -|-|-|-|-|T|-
                -|-|-|-|-|I|-
                -|C|U|T|E|R|-
                -|-|-|-|-|-|-
                -|-|-|-|-|-|-
                -|-|-|-|-|-|-
            """),
            newBoard: Board(pattern: """
                -|-|-|-|A|S|-
                -|-|-|-|E|T|-
                -|-|-|-|-|I|-
                -|C|U|T|E|R|-
                -|-|-|-|-|-|-
                -|-|-|-|-|-|-
                -|-|-|-|-|-|-
            """))
    }

    func testAdjacentVerticalPlaysOnBottomLeft() {
        expectAdjacentVerticalPlays(
            vertical: "AE",
            horizontalFaces: ["TA", "HE"],
            for: Board(pattern: """
                -|T|-|-|-|-|-
                -|H|-|-|-|-|-
                -|I|-|-|-|-|-
                -|S|A|U|T|E|-
                -|-|-|-|-|-|-
                -|-|-|-|-|-|-
                -|-|-|-|-|-|-
            """),
            newBoard: Board(pattern: """
                -|T|A|-|-|-|-
                -|H|E|-|-|-|-
                -|I|-|-|-|-|-
                -|S|A|U|T|E|-
                -|-|-|-|-|-|-
                -|-|-|-|-|-|-
                -|-|-|-|-|-|-
            """))
    }

    func testAdjacentVerticalPlaysOnBottomRight() {
        expectAdjacentVerticalPlays(
            vertical: "RE",
            horizontalFaces: ["AR", "RE"],
            for: Board(pattern: """
                -|-|-|-|-|-|-
                -|-|-|-|-|-|-
                -|-|-|-|-|-|-
                -|S|A|U|T|E|-
                -|T|-|-|-|-|-
                -|I|-|-|-|-|-
                -|R|-|-|-|-|-
            """),
            newBoard: Board(pattern: """
                -|-|-|-|-|-|-
                -|-|-|-|-|-|-
                -|-|-|-|-|-|-
                -|S|A|U|T|E|-
                -|T|-|-|-|-|-
                -|A|R|-|-|-|-
                -|R|E|-|-|-|-
            """))
    }

    func expectCorner(
        horizontal: String,
        vertical: String,
        for oldBoard: Board,
        newBoard: Board,
        file: StaticString = #file,
        line: UInt = #line) {
        let result = oldBoard.calculatePlacement(comparingWith: newBoard)
        switch result {
        case let .success(placement):
            XCTAssertEqual(placement.mainPlacement.horizontal.faces, horizontal, file: file, line: line)
            XCTAssertEqual(placement.mainPlacement.vertical.faces, vertical, file: file, line: line)
            XCTAssertTrue(placement.verticalFaces.isEmpty, placement.verticalFaces.joined(separator: ", "), file: file, line: line)
            XCTAssertTrue(placement.horizontalFaces.isEmpty, placement.horizontalFaces.joined(separator: ", "), file: file, line: line)
        default:
            XCTFail("Expected success", file: file, line: line)
        }
    }

    func testTopRightCornerSingleTilePlayIsValid() {
        expectCorner(
            horizontal: "BA",
            vertical: "AD",
            for: Board(pattern: """
                   -|-|-|-|-
                   -|B|-|-|-
                   -|E|D|-|-
                   -|-|-|-|-
                   -|-|-|-|-
               """),
            newBoard: Board(pattern: """
                   -|-|-|-|-
                   -|-|A|-|-
                   -|-|-|-|-
                   -|-|-|-|-
                   -|-|-|-|-
               """))
    }

    func testTopLeftCornerSingleTilePlayIsValid() {
        expectCorner(
            horizontal: "BA",
            vertical: "BE",
            for: Board(pattern: """
                   -|-|-|-|-
                   -|-|A|-|-
                   -|E|D|-|-
                   -|-|-|-|-
                   -|-|-|-|-
               """),
            newBoard: Board(pattern: """
                   -|-|-|-|-
                   -|B|-|-|-
                   -|-|-|-|-
                   -|-|-|-|-
                   -|-|-|-|-
               """))
    }

    func testBottomLeftCornerSingleTilePlayIsValid() {
        expectCorner(
            horizontal: "ED",
            vertical: "BE",
            for: Board(pattern: """
                   -|-|-|-|-
                   -|B|A|-|-
                   -|-|D|-|-
                   -|-|-|-|-
                   -|-|-|-|-
               """),
            newBoard: Board(pattern: """
                   -|-|-|-|-
                   -|-|-|-|-
                   -|E|-|-|-
                   -|-|-|-|-
                   -|-|-|-|-
               """))
    }

    func testBottomRightCornerSingleTilePlayIsValid() {
        expectCorner(
            horizontal: "ED",
            vertical: "AD",
            for: Board(pattern: """
                   -|-|-|-|-
                   -|B|A|-|-
                   -|E|-|-|-
                   -|-|-|-|-
                   -|-|-|-|-
               """),
            newBoard: Board(pattern: """
                   -|-|-|-|-
                   -|-|-|-|-
                   -|-|D|-|-
                   -|-|-|-|-
                   -|-|-|-|-
               """))
    }
}

extension Sequence where Element == Spot {
    var faces: String {
        sorted().compactMap { $0.tile?.face }.joined()
    }
}
