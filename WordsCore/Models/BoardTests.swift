//
//  BoardTests.swift
//  WordsCore
//
//  Created by Chris on 09/11/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import XCTest
@testable import WordsCore

extension Board {
    init(pattern: String) {
        let rows = pattern.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }

        self.init(spots: rows.enumerated()
            .reduce(into: []) { buffer, rowElement in
                let (row, rowContent) = rowElement
                let columns = rowContent.components(separatedBy: "|")
                    .map { $0.trimmingCharacters(in: .whitespaces) }

                buffer.append(columns.enumerated()
                    .reduce(into: [Spot]()) { buffer, columnElement in
                        let (column, columnContent) = columnElement
                        let middle = row == rows.count / 2 && column == columns.count / 2
                        switch columnContent {
                        case "-": buffer.append(.empty(row, column, middle: middle))
                        default: buffer.append(.tile(.init(face: columnContent, value: 1), at: row, column, middle: middle))
                        }
                })
        })
    }
}

class BoardTests: XCTestCase {
    func testPattern() {
        let board = Board(pattern: """
            -|A|-
            -|B|-
            -|C|-
        """)
        let expected: [[Spot]] = [
            [
                .empty(0, 0), .tile(.init(face: "A", value: 1), at: 0, 1), .empty(0, 2),
                .empty(1, 0), .tile(.init(face: "B", value: 1), at: 1, 1, middle: true), .empty(1, 2),
                .empty(2, 0), .tile(.init(face: "C", value: 1), at: 2, 1), .empty(2, 2)
            ]
        ]

        zip(board.spots, expected).forEach { lhs, rhs in
            zip(lhs, rhs).forEach { actual, expectation in
                XCTAssertEqual(actual.tile?.face, expectation.tile?.face)
                XCTAssertEqual(actual.row, expectation.row)
                XCTAssertEqual(actual.column, expectation.column)
                XCTAssertEqual(actual.middle, expectation.middle)
            }
        }
    }
}
