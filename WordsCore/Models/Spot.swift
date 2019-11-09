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

    func placement(newSpots: [Spot]) -> Placement {
        let newlyFilled = newSpots.filter { newSpot in
            guard let oldSpot = self.first(where: { $0.row == newSpot.row && $0.column == newSpot.column }) else {
                return true
            }
            return oldSpot.tile == nil && newSpot.tile != nil
        }

        let unionLeft = filter { oldSpot in
            guard let newSpot = self.first(where: { $0.row == oldSpot.row && $0.column == oldSpot.column }) else {
                return true
            }
            return (oldSpot.tile ?? newSpot.tile) != nil
        }

        let unionRight = newSpots.filter { newSpot in
            guard let oldSpot = self.first(where: { $0.row == newSpot.row && $0.column == newSpot.column }) else {
                return true
            }
            return (oldSpot.tile ?? newSpot.tile) != nil
        }

        let allFilled = Set(unionLeft + unionRight)

        let matchingRow = newlyFilled.row.map { row in allFilled.filter { $0.row == row } }?.sorted() ?? []
        let matchingColumn = newlyFilled.column.map { column in allFilled.filter { $0.column == column } }?.sorted() ?? []

        let sequentialColumn = matchingRow.horizontal
        let sequentialRow = matchingColumn.vertical

        switch (sequentialColumn.count, sequentialRow.count) {
        case (1..., 1): return Placement(horizontal: sequentialColumn, vertical: [])
        case (1, 1...): return Placement(horizontal: [], vertical: sequentialRow)
        default: return Placement(horizontal: sequentialColumn, vertical: sequentialRow)
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

extension Sequence where Element == Int {
    var areSequential: Bool {
        let all = Array(self)
        guard let min = all.min(), let max = all.max(), min != max, (min...max).count == all.count else {
            return false
        }
        return true
    }
}

extension Sequence where Element == Spot {
    var horizontal: [Spot] {
        return columns.areSequential && row != nil ? Array(self) : []
    }

    var vertical: [Spot] {
        return rows.areSequential && column != nil ? Array(self) : []
    }
}
