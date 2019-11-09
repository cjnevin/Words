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

    public var interactive: Bool {
        return tile?.movable ?? true
    }

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

    var isHorizontal: Bool {
        row != nil
    }

    var isVertical: Bool {
        column != nil
    }

    private func newlyFilled(_ newSpots: [Spot]) -> [Spot] {
        newSpots.filter { newSpot in
            guard let oldSpot = self.first(where: { $0.row == newSpot.row && $0.column == newSpot.column }) else {
                return true
            }
            return oldSpot.tile == nil && newSpot.tile != nil
        }
    }

    private func unionFilled(_ newSpots: [Spot]) -> [Spot] {
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

        return Set(unionLeft + unionRight).sorted()
    }

    func placement(newSpots: [Spot]) -> Placement {
        let newlyFilled = self.newlyFilled(newSpots)
        let unionFilled = self.unionFilled(newSpots)

        let matchingRow = newlyFilled.row.map { row in unionFilled.filter { $0.row == row } }?.sorted() ?? []
        let matchingColumn = newlyFilled.column.map { column in unionFilled.filter { $0.column == column } }?.sorted() ?? []

        let sequentialColumn = matchingRow.horizontal
        let sequentialRow = matchingColumn.vertical

        switch (sequentialColumn.count, sequentialRow.count) {
        case (1..., 1): return Placement(horizontal: sequentialColumn, vertical: [])
        case (1, 1...): return Placement(horizontal: [], vertical: sequentialRow)
        default: return Placement(horizontal: sequentialColumn, vertical: sequentialRow)
        }
    }

    func `in`(column: Int) -> [Spot] {
        filter { $0.column == column }
    }

    func `in`(row: Int) -> [Spot] {
        filter { $0.row == row }
    }

    func verticalIntersections(in filled: [Spot]) -> [Placement] {
        compactMap { spot in
            filled.in(column: spot.column)
                .intersection(with: spot, mapping: { $0.row })?
                .sorted()
        }.map { Placement(horizontal: [], vertical: $0) }
    }

    func horizontalIntersections(in filled: [Spot]) -> [Placement] {
        compactMap { spot in
            filled.in(row: spot.row)
                .intersection(with: spot, mapping: { $0.column })?
                .sorted()
        }.map { Placement(horizontal: $0, vertical: []) }
    }

    func compoundPlacement(_ allNewFilledSpots: [Spot]) -> PlacementResult {
        let mainPlacement = placement(newSpots: allNewFilledSpots)
        let newlyFilled = self.newlyFilled(mainPlacement.spots)
        let unionFilled = self.unionFilled(mainPlacement.spots)

        guard !newlyFilled.isEmpty else {
            return .failure(.tileNotPlaced)
        }

        let allNewTilesInMainPlacement = newlyFilled.count == self.newlyFilled(allNewFilledSpots).count
        guard allNewTilesInMainPlacement else {
            return .failure(.tileMisaligned)
        }

        let intersectsMiddle = unionFilled.contains(where: { $0.middle })
        guard intersectsMiddle else {
            return .failure(.tileMustIntersectMiddle)
        }

        let isVertical = !mainPlacement.vertical.isEmpty
        let horizontalIntersections = isVertical ? newlyFilled.horizontalIntersections(in: unionFilled) : []

        let isHorizontal = !mainPlacement.horizontal.isEmpty
        let verticalIntersections = isHorizontal ? newlyFilled.verticalIntersections(in: unionFilled) : []

        if filled.isEmpty {
            if !horizontalIntersections.isEmpty || !verticalIntersections.isEmpty {
                return .failure(.tileCannotIntersectOnFirstPlay)
            }
        } else {
            if mainPlacement.spots.count == newlyFilled.count, horizontalIntersections.isEmpty, verticalIntersections.isEmpty {
                return .failure(.tileMustIntersectExistingTile)
            }
        }

        let placement = CompoundPlacement(
            mainPlacement: mainPlacement,
            horizontalIntersections: horizontalIntersections,
            verticalIntersections: verticalIntersections)

        return .success(placement)
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
