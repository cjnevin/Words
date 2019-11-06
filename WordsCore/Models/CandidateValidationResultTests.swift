//
//  CandidateValidationResultTests.swift
//  words
//
//  Created by Chris on 06/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import XCTest
@testable import WordsCore

class CandidateValidationResultTests: XCTestCase {
    func testFlatteningOfBothValidResultsInValid() {
        let many: [CandidateValidationResult] = [
            .validCandidates([Candidate(spots: [.empty(1, 1)], tiles: [.a])!]),
            .validCandidates([Candidate(spots: [.empty(1, 2)], tiles: [.b])!])
        ]
        many.flattened().expectValidTiles([.a, .b])
    }

    func testFlatteningWithInvalidLeftResultsInInvalid() {
        let many: [CandidateValidationResult] = [
            .invalidCandidates([Candidate(spots: [.empty(1, 1)], tiles: [.a])!]),
            .validCandidates([Candidate(spots: [.empty(1, 2)], tiles: [.b])!])
        ]
        many.flattened().expectInvalidTiles([.a])
    }

    func testFlatteningWithInvalidRightResultsInInvalid() {
        let many: [CandidateValidationResult] = [
            .validCandidates([Candidate(spots: [.empty(1, 1)], tiles: [.a])!]),
            .invalidCandidates([Candidate(spots: [.empty(1, 2)], tiles: [.b])!])
        ]
        many.flattened().expectInvalidTiles([.b])
    }

    func testFlatteningWithBothInvalidResultsInInvalid() {
        let many: [CandidateValidationResult] = [
            .invalidCandidates([Candidate(spots: [.empty(1, 1)], tiles: [.a])!]),
            .invalidCandidates([Candidate(spots: [.empty(1, 2)], tiles: [.b])!])
        ]
        many.flattened().expectInvalidTiles([.a, .b])
    }
}

extension CandidateValidationResult {
    func expectValidTiles(_ tiles: [Tile], file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .validCandidates(matching):
            XCTAssertEqual(matching.flatMap { $0.tiles }, tiles, file: file, line: line)
        default:
            XCTFail("Unexpectedly got invalid candidates.", file: file, line: line)
        }
    }

    func expectInvalidTiles(_ tiles: [Tile], file: StaticString = #file, line: UInt = #line) {
        switch self {
        case let .invalidCandidates(matching):
        XCTAssertEqual(matching.flatMap { $0.tiles }, tiles, file: file, line: line)
        case .validCandidates:
            XCTFail("Unexpectedly got valid candidates.", file: file, line: line)
        }
    }
}
