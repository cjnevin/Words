//
//  CandidateTests.swift
//  wordsTests
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import XCTest
@testable import WordsCore

class CandidateTests: XCTestCase {
    func testInitializeWithLessTilesThanSpotsResultsInNull() {
        let candidate = Candidate(spots: [.empty(1, 1), .empty(1, 2)], tiles: [.a])
        XCTAssertNil(candidate)
    }

    func testInitializeWithNoTilesResultsInNull() {
        let candidate = Candidate(spots: [.empty(1, 1)], tiles: [])
        XCTAssertNil(candidate)
    }

    func testInitializeWithNoSpotsResultsInNull() {
        let candidate = Candidate(spots: [], tiles: [.a])
        XCTAssertNil(candidate)
    }

    func testInitializeWithMatchingSpotsAndTilesResultsInNull() {
        let candidate = Candidate(spots: [.empty(1, 1)], tiles: [.a])
        XCTAssertNotNil(candidate)
    }

    func testWordIsAConcatenatedRepresentationOfTilesInOrder() {
        let candidate = Candidate(spots: [.empty(1, 1), .empty(1, 2), .empty(1, 3)], tiles: [.a, .b, .c])
        XCTAssertEqual(candidate?.word, "ABC")
    }

    func testWordValidationSuccess() {
        let candidate = Candidate(spots: [.empty(1, 1), .empty(1, 2), .empty(1, 3)], tiles: [.a, .b, .c])!
        candidate.validate(with: MockWordValidator()).expectValidTiles([.a, .b, .c])
    }

    func testWordValidationMultipleSuccess() {
        let candidates: [Candidate] = [
            Candidate(spots: [.empty(1, 1), .empty(1, 2), .empty(1, 3)], tiles: [.a, .b, .c])!,
            Candidate(spots: [.empty(2, 1), .empty(2, 2), .empty(2, 3)], tiles: [.d, .e, .f])!
        ]
        candidates.validate(with: MockWordValidator()).expectValidTiles([.a, .b, .c, .d, .e, .f])
    }

    func testWordValidationMultipleFailure() {
        let candidates: [Candidate] = [
            Candidate(spots: [.empty(1, 1), .empty(1, 2), .empty(1, 3)], tiles: [.a, .b, .c])!,
            Candidate(spots: [.empty(2, 1), .empty(2, 2), .empty(2, 3)], tiles: [.d, .e, .f])!
        ]
        let validator = MockWordValidator()
        validator.isValid = false
        candidates.validate(with: validator).expectInvalidTiles([.a, .b, .c, .d, .e, .f])
    }

    func testCalculateScoreForSingleWordWithNoMultipliers() {
        let oldBoard = Board(spots: .empty(rows: 3, columns: 3))
        let newBoard = Board(spots: [
            .empty(row: 0, columns: 3),
            .filled(row: 1, tiles: [.a, .b, .c]),
            .empty(row: 2, columns: 3)
        ])
        let candidate = Candidate(spots: .empty(row: 1, columns: 3), tiles: [.a, .b, .c])!
        let score = candidate.calculateScore(oldBoard: oldBoard, newBoard: newBoard)
        XCTAssertEqual(score, Tile.a.value + Tile.b.value + Tile.c.value)
    }

    func testCalculateScoreForSingleWordWithLetterMultiplier() {
        let oldBoard = Board(spots: .empty(rows: 3, columns: 3))
        let newBoard = Board(spots: [
            .empty(row: 0, columns: 3),
            [.tile(.a, at: 1, 0, multiplier: 2, wordMultiplier: 1),
             .tile(.b, at: 1, 1, multiplier: 3, wordMultiplier: 1),
             .tile(.c, at: 1, 2, multiplier: 4, wordMultiplier: 1)],
            .empty(row: 2, columns: 3)
        ])
        let candidate = Candidate(spots: .empty(row: 1, columns: 3), tiles: [.a, .b, .c])!
        let score = candidate.calculateScore(oldBoard: oldBoard, newBoard: newBoard)
        XCTAssertEqual(score, (Tile.a.value * 2) + (Tile.b.value * 3) + (Tile.c.value * 4))
    }

    func testCalculateScoreForSingleWordWithIgnoredLetterMultiplier() {
        var oldBoard = Board(spots: .empty(rows: 3, columns: 3))
        oldBoard.spots[1][1] = .tile(.b, at: 1, 1, multiplier: 2, wordMultiplier: 1)
        let newBoard = Board(spots: [
            .empty(row: 0, columns: 3),
            [.tile(.a, at: 1, 0, multiplier: 1, wordMultiplier: 1),
             .tile(.b, at: 1, 1, multiplier: 2, wordMultiplier: 1),
             .tile(.c, at: 1, 2, multiplier: 1, wordMultiplier: 1)],
            .empty(row: 2, columns: 3)
        ])
        let candidate = Candidate(spots: .empty(row: 1, columns: 3), tiles: [.a, .b, .c])!
        let score = candidate.calculateScore(oldBoard: oldBoard, newBoard: newBoard)
        XCTAssertEqual(score, Tile.a.value + Tile.b.value + Tile.c.value)
    }

    func testCalculateScoreForSingleWordWithWordMultiplier() {
        let oldBoard = Board(spots: .empty(rows: 3, columns: 3))
        let newBoard = Board(spots: [
            .empty(row: 0, columns: 3),
            [.tile(.a, at: 1, 0, multiplier: 1, wordMultiplier: 2),
             .tile(.b, at: 1, 1, multiplier: 1, wordMultiplier: 3),
             .tile(.c, at: 1, 2, multiplier: 1, wordMultiplier: 4)],
            .empty(row: 2, columns: 3)
        ])
        let candidate = Candidate(spots: .empty(row: 1, columns: 3), tiles: [.a, .b, .c])!
        let score = candidate.calculateScore(oldBoard: oldBoard, newBoard: newBoard)
        XCTAssertEqual(score, (((Tile.a.value + Tile.b.value + Tile.c.value) * 2) * 3) * 4)
    }

    func testCalculateScoreForSingleWordWithIgnoredWordMultiplier() {
        var oldBoard = Board(spots: .empty(rows: 3, columns: 3))
        oldBoard.spots[1][1] = .tile(.b, at: 1, 1, multiplier: 1, wordMultiplier: 2)
        let newBoard = Board(spots: [
            .empty(row: 0, columns: 3),
            [.tile(.a, at: 1, 0, multiplier: 1, wordMultiplier: 1),
             .tile(.b, at: 1, 1, multiplier: 1, wordMultiplier: 2),
             .tile(.c, at: 1, 2, multiplier: 1, wordMultiplier: 1)],
            .empty(row: 2, columns: 3)
        ])
        let candidate = Candidate(spots: .empty(row: 1, columns: 3), tiles: [.a, .b, .c])!
        let score = candidate.calculateScore(oldBoard: oldBoard, newBoard: newBoard)
        XCTAssertEqual(score, Tile.a.value + Tile.b.value + Tile.c.value)
    }
}
