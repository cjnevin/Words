//
//  CandidateCollectionResultTests.swift
//  words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import XCTest
@testable import WordsCore

class CandidateCollectionResultTests: XCTestCase {
    func testFlatteningOfBothCandidatesResultsInCandidates() {
        let many: [CandidateCollectionResult] = [
            .candidates([Candidate(spots: [.empty(1, 1)], tiles: [.a])!]),
            .candidates([Candidate(spots: [.empty(1, 2)], tiles: [.b])!])
        ]
        many.flattened().expectTiles([.a, .b])
    }

    func testFlatteningWithInvalidLeftResultsInInvalid() {
        let placement = Placement(horizontal: .empty(row: 1, columns: 1), vertical: [])
        let many: [CandidateCollectionResult] = [
            .invalidPlacements([placement]),
            .candidates([Candidate(spots: [.empty(1, 2)], tiles: [.b])!])
        ]
        many.flattened().expectInvalidPlacement(at: placement)
    }

    func testFlatteningWithInvalidRightResultsInInvalid() {
        let placement = Placement(horizontal: .empty(row: 1, columns: 1), vertical: [])
        let many: [CandidateCollectionResult] = [
            .candidates([Candidate(spots: [.empty(1, 1)], tiles: [.a])!]),
            .invalidPlacements([placement])
        ]
        many.flattened().expectInvalidPlacement(at: placement)
    }

    func testFlatteningWithBothInvalidResultsInInvalid() {
        let hPlacement = Placement(horizontal: .empty(row: 1, columns: 1), vertical: [])
        let vPlacement = Placement(horizontal: [], vertical: .empty(row: 1, columns: 1))
        let many: [CandidateCollectionResult] = [
            .invalidPlacements([hPlacement]),
            .invalidPlacements([vPlacement])
        ]
        many.flattened().expectInvalidPlacements(at: [hPlacement, vPlacement])
    }
}

extension CandidateCollectionResult {
    func expectTiles(_ tiles: [Tile], file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .candidates(matching):
            XCTAssertEqual(matching.flatMap { $0.tiles }, tiles, file: file, line: line)
        default:
            XCTFail("Unexpectedly got invalid placement result.", file: file, line: line)
        }
    }

    func expectInvalidPlacement(at placement: Placement, file: StaticString = #file, line: UInt = #line) {
        expectInvalidPlacements(at: [placement], file: file, line: line)
    }

    func expectInvalidPlacements(at placements: [Placement], file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .invalidPlacements(matching):
            XCTAssertEqual(matching, placements)
        case .candidates:
            XCTFail("Unexpectedly got candidates.", file: file, line: line)
        }
    }
}
