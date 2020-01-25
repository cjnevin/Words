//
//  SequenceTests.swift
//  wordsTests
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import XCTest
@testable import WordsCore

class SequenceTests: XCTestCase {
    func expect(_ n: [Int], matches: [Int], intersectingAt: Int, line: UInt = #line) {
        let intersection = n.intersection(with: intersectingAt, mapping: { $0 })?.sorted()
        XCTAssertEqual(intersection ?? [], matches, line: line)
    }

    func testIntersectionBreaksOnMissingAdjacentNumbers() {
        expect([0, 2, 3], matches: [2, 3], intersectingAt: 2)
        expect([1, 2, 4], matches: [1, 2], intersectingAt: 2)
    }

    func testIntersectionFromLeft() {
        expect([0, 1, 3], matches: [0, 1], intersectingAt: 0)
    }

    func testIntersectionFromMiddle() {
        expect([1, 2, 3], matches: [1, 2, 3], intersectingAt: 2)
    }

    func testIntersectionFromRight() {
        expect([0, 2, 3], matches: [2, 3], intersectingAt: 3)
    }

    func testIntersectionOutsideOfBoundsReturnsNoMatches() {
        expect([1, 2, 3], matches: [], intersectingAt: 0)
        expect([1, 2, 3], matches: [], intersectingAt: 4)
    }

    func testAreSequential() {
        XCTAssertTrue([1, 2, 3].areSequential)
        XCTAssertFalse([1, 3, 4].areSequential)
    }
}
