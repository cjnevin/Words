//
//  Spot+Extensions.swift
//  wordsTests
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
@testable import WordsCore

enum Alignment: Equatable {
    case horizontal
    case vertical
    case both
    case none
}

extension Spot {
    static func empty(_ row: Int, _ column: Int, middle: Bool = false, multiplier: Int = 1, wordMultiplier: Int = 1) -> Spot {
        return Spot(row: row, column: column, middle: middle, multiplier: multiplier, wordMultiplier: wordMultiplier, tile: nil)
    }

    static func tile(_ tile: Tile, at row: Int, _ column: Int, middle: Bool = false, multiplier: Int = 1, wordMultiplier: Int = 1) -> Spot {
        return Spot(row: row, column: column, middle: middle, multiplier: multiplier, wordMultiplier: wordMultiplier, tile: tile)
    }
}

extension Sequence where Element == Spot {
    var alignment: Alignment {
        switch (isHorizontal, isVertical) {
            case (true, true): return .both
            case (true, false): return .horizontal
            case (false, true): return .vertical
            case (false, false): return .none
        }
    }

    var isHorizontal: Bool {
        row != nil
    }

    var isVertical: Bool {
        column != nil
    }

    var isAligned: Bool {
        isHorizontal || isVertical
    }

    var face: String {
        return sorted().compactMap { $0.tile?.face }.joined()
    }

    static func empty(row: Int, columns: Int) -> [Spot] {
        (0..<columns).reduce(into: []) { $0.append(Spot.empty(row, $1)) }
    }

    static func filled(row: Int, tiles: [Tile]) -> [Spot] {
        tiles.enumerated().reduce(into: []) { $0.append(Spot.tile($1.element, at: row, $1.offset)) }
    }
}

extension Sequence where Element == [Spot] {
    static func empty(rows: Int, columns: Int) -> [[Spot]] {
        (0..<rows).reduce(into: []) { $0.append([Spot].empty(row: $1, columns: columns)) }
    }
}
