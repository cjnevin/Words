//
//  SpotTests.swift
//  WordsCore
//
//  Created by Chris on 09/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import XCTest
@testable import WordsCore

class SpotTests: XCTestCase {
    func testEmptyRowsAreCorrect() {
        XCTAssertEqual([Spot].empty(column: 0, rows: 3), [
            .empty(0, 0), .empty(1, 0), .empty(2, 0)
        ])
    }

    func testEmptyColumnsAreCorrect() {
        XCTAssertEqual([Spot].empty(row: 0, columns: 3), [
            .empty(0, 0), .empty(0, 1), .empty(0, 2)
        ])
    }

    func testFilledRowsAreCorrect() {
        XCTAssertEqual([Spot].filled(column: 0, tiles: [.a, .b, .c]), [
            .tile(.a, at: 0, 0), .tile(.b, at: 1, 0), .tile(.c, at: 2, 0)
        ])
    }

    func testFilledColumnsAreCorrect() {
        XCTAssertEqual([Spot].filled(row: 0, tiles: [.a, .b, .c]), [
            .tile(.a, at: 0, 0), .tile(.b, at: 0, 1), .tile(.c, at: 0, 2)
        ])
    }

    func testHorizontalPlacementIsValid() {
        let oldSpots = [Spot].empty(row: 0, columns: 3)
        let newSpots = [Spot].filled(row: 0, tiles: [.a, .b, .c])
        let placement = oldSpots.placement(newSpots: newSpots)
        XCTAssertEqual(placement.horizontal.count, 3)
        XCTAssertEqual(placement.vertical.count, 0)
    }

    func testHorizontalPlacementIsInvalidIfMissingMiddleTile() {
        let oldSpots: [Spot] = .empty(row: 0, columns: 3)
        let newSpots: [Spot] = [.tile(.a, at: 0, 0), .empty(0, 1), .tile(.c, at: 0, 2)]
        let placement = oldSpots.placement(newSpots: newSpots)
        XCTAssertEqual(placement.spots.count, 0)
    }

    func testHorizontalPlacementIsInvalidIfTwoWordsHaveASpaceBetweenThem() {
        let oldSpots: [Spot] = .empty(row: 0, columns: 5)
        let newSpots: [Spot] = [.tile(.a, at: 0, 0), .tile(.b, at: 0, 1), .empty(0, 2), .tile(.c, at: 0, 3), .tile(.d, at: 0, 4)]
        let placement = oldSpots.placement(newSpots: newSpots)
        XCTAssertEqual(placement.spots.count, 0)
    }

    func testVerticalPlacementIsValid() {
        let oldSpots = [Spot].empty(column: 0, rows: 3)
        let newSpots = [Spot].filled(column: 0, tiles: [.a, .b, .c])
        let placement = oldSpots.placement(newSpots: newSpots)
        XCTAssertEqual(placement.vertical.count, 3)
        XCTAssertEqual(placement.horizontal.count, 0)
    }

    func testVerticalPlacementIsInvalidIfMissingMiddleTile() {
        let oldSpots: [Spot] = .empty(column: 0, rows: 3)
        let newSpots: [Spot] = [.tile(.a, at: 0, 0), .empty(1, 0), .tile(.c, at: 2, 0)]
        let placement = oldSpots.placement(newSpots: newSpots)
        XCTAssertEqual(placement.spots.count, 0)
    }

    func testVerticalPlacementIsInvalidIfTwoWordsHaveASpaceBetweenThem() {
        let oldSpots: [Spot] = .empty(column: 0, rows: 5)
        let newSpots: [Spot] = [.tile(.a, at: 0, 0), .tile(.b, at: 1, 0), .empty(2, 0), .tile(.c, at: 3, 0), .tile(.d, at: 4, 0)]
        let placement = oldSpots.placement(newSpots: newSpots)
        XCTAssertEqual(placement.spots.count, 0)
    }
}
