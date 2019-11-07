//
//  Spot.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

public struct Spot: Equatable, Hashable, Comparable, Codable, Identifiable {
    public static func < (lhs: Spot, rhs: Spot) -> Bool {
        if lhs.row == rhs.row {
            return lhs.column < rhs.column
        } else if lhs.column == rhs.column {
            return lhs.row < rhs.row
        } else {
            return lhs.column < rhs.column || lhs.row < rhs.row
        }
    }

    public var id: String { return "\(row), \(column)" }

    let row: Int
    let column: Int
    public let middle: Bool
    public let multiplier: Int
    public let wordMultiplier: Int
    public internal(set) var tile: Tile?

    var tileScore: Int {
        return multiplier * (tile?.value ?? 1)
    }
    
    public init(
        row: Int,
        column: Int,
        middle: Bool,
        multiplier: Int,
        wordMultiplier: Int,
        tile: Tile?) {
        self.row = row
        self.column = column
        self.middle = middle
        self.multiplier = multiplier
        self.wordMultiplier = wordMultiplier
        self.tile = tile
    }
}

extension Sequence where Element == Spot {
    var columns: Set<Int> {
        Set(map { $0.column })
    }

    var column: Int? {
        columns.count == 1 ? columns.first : nil
    }

    var rows: Set<Int> {
        Set(map { $0.row })
    }

    var row: Int? {
        rows.count == 1 ? rows.first : nil
    }

    var filled: [Spot] {
        reduce(into: []) { $0 += $1.tile != nil ? [$1] : [] }
    }

    private func placement(newSpots: [Spot]) -> Placement {
        let oldFilled = Set(self)
        let newFilled = Set(newSpots)
        let diff = newFilled.subtracting(oldFilled)
        let filled = oldFilled.union(diff)
        let h = diff.row.map { row in filled.filter { $0.row == row } }?.sorted() ?? []
        let v = diff.column.map { column in filled.filter { $0.column == column } }?.sorted() ?? []

        // FIXME: Check each index is filled, i.e. row 8-10 no skipped spots
        // TODO: Write a failing test first

        switch (h.count, v.count) {
        case (1..., 1): return Placement(horizontal: h, vertical: [])
        case (1, 1...): return Placement(horizontal: [], vertical: v)
        default: return Placement(horizontal: h, vertical: v)
        }
    }

    private func horizontalIntersections(for placement: Placement) -> [Placement] {
        return placement.vertical.reduce(into: []) { buffer, item in
            let sameRow = filter { $0.row == item.row }
            if let intersection = sameRow.intersection(with: item, mapping: { $0.column })?.sorted() {
                buffer.append(Placement(horizontal: intersection, vertical: []))
            }
        }
    }

    private func verticalIntersections(for placement: Placement) -> [Placement] {
        return placement.horizontal.reduce(into: [Placement]()) { buffer, item in
            let sameColumn = filter { $0.column == item.column }
            if let intersection = sameColumn.intersection(with: item, mapping: { $0.row })?.sorted() {
                buffer.append(Placement(horizontal: [], vertical: intersection))
            }
        }
    }

    func compoundPlacement(newSpots: [Spot]) -> CompoundPlacement {
        let original = placement(newSpots: newSpots)
        let filled = Array(Set(newSpots).union(Set(self)))
        return CompoundPlacement(
            mainPlacement: original,
            horizontalIntersections: filled.horizontalIntersections(for: original),
            verticalIntersections: filled.verticalIntersections(for: original))
    }
}

extension Sequence where Element == [Spot] {
    var filled: [Spot] {
        reduce(into: []) { $0 += $1.filled }
    }
}
