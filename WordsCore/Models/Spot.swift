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

    public struct Status: OptionSet, Codable, Hashable {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }

        public static let fixed = Status(rawValue: 1 << 0)
        public static let valid = Status(rawValue: 1 << 1)
        public static let invalid = Status(rawValue: 1 << 2)
    }

    public var id: String { return "\(row), \(column)" }

    let row: Int
    let column: Int
    public let middle: Bool
    public let multiplier: Int
    public let wordMultiplier: Int
    public internal(set) var tile: Tile?
    public internal(set) var status: Status = []

    public var interactive: Bool {
        return tile?.movable ?? true
    }

    var tileScore: Int {
        return multiplier * (tile?.value ?? 1)
    }

    func sameAs(_ spot: Spot) -> Bool {
        row == spot.row && column == spot.column
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

    private func zip(with spots: [Spot]) -> [(oldSpot: Spot?, newSpot: Spot?)] {
        map { oldSpot in
            (oldSpot, spots.first { newSpot in
                oldSpot.sameAs(newSpot)
            })
        } + spots.map { newSpot in
            (self.first { oldSpot in
                oldSpot.sameAs(newSpot)
            }, newSpot)
        }
    }

    func newlyFilled(_ newSpots: [Spot]) -> [Spot] {
        Set(zip(with: newSpots).compactMap {
            $0?.tile == nil && $1?.tile != nil ? $1 : nil
        }).sorted()
    }

    func unionFilled(_ newSpots: [Spot]) -> [Spot] {
        Set(zip(with: newSpots).compactMap {
            ($0?.tile != nil) ? $0 : ($1?.tile != nil) ? $1 : nil
        }).sorted()
    }

    func sequentialColumn(around: [Spot]) -> [Spot] {
        guard let row = around.row, let min = around.min(), let max = around.max() else {
            return []
        }
        let inRow = filled.filter { $0.row == row }
        var items: [Spot] = around
        if let minColumn = inRow.columns.min() {
            var index = min.column - 1
            repeat {
                if let first = inRow.first(where: { $0.column == index }) {
                    items.append(first)
                } else {
                    break
                }
                index -= 1
            } while index >= minColumn
        }
        items.append(contentsOf: inRow.filter { $0.column > min.column && $0.column < max.column })
        if let maxColumn = inRow.columns.max() {
            var index = max.column + 1
            repeat {
                if let first = inRow.first(where: { $0.column == index }) {
                    items.append(first)
                } else {
                    break
                }
                index += 1
            } while index <= maxColumn
        }
        return items.horizontal.sorted()
    }

    func sequentialRow(around: [Spot]) -> [Spot] {
        guard let column = around.column, let min = around.min(), let max = around.max() else {
            return []
        }
        let inColumn = filled.filter { $0.column == column }
        var items: [Spot] = around
        if let minRow = inColumn.rows.min() {
            var index = min.row - 1
            repeat {
                if let first = inColumn.first(where: { $0.row == index }) {
                    items.append(first)
                } else {
                    break
                }
                index -= 1
            } while index >= minRow
        }
        items.append(contentsOf: inColumn.filter { $0.row > min.row && $0.row < max.row })
        if let maxRow = inColumn.rows.max() {
            var index = max.row + 1
            repeat {
                if let first = inColumn.first(where: { $0.row == index }) {
                    items.append(first)
                } else {
                    break
                }
                index += 1
            } while index <= maxRow
        }
        return items.vertical.sorted()
    }

    func placement(newSpots: [Spot]) -> Placement {
        let newlyFilled = self.newlyFilled(newSpots)
        let sequentialColumn = self.sequentialColumn(around: newlyFilled)
        let sequentialRow = self.sequentialRow(around: newlyFilled)

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
        }
        .map { Placement(horizontal: [], vertical: $0) }
        .unique
    }

    func horizontalIntersections(in filled: [Spot]) -> [Placement] {
        compactMap { spot in
            filled.in(row: spot.row)
                .intersection(with: spot, mapping: { $0.column })?
                .sorted()
        }
        .map { Placement(horizontal: $0, vertical: []) }
        .unique
    }

    func compoundPlacement(_ allNewFilledSpots: [Spot]) -> PlacementResult {
        let mainPlacement = placement(newSpots: allNewFilledSpots)
        let newlyFilled = self.newlyFilled(mainPlacement.spots)
        let unionFilled = self.unionFilled(mainPlacement.spots)

        guard !newlyFilled.isEmpty else {
            return .failure(.tileNotPlaced)
        }

        let allNewTilesInMainPlacement = Set(newlyFilled).count == self.newlyFilled(allNewFilledSpots).count
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

extension Sequence where Element: Hashable {
    var unique: [Element] {
        Array(Set(self))
    }
}

extension Sequence where Element == [Spot] {
    func doesNotContainStatus(_ status: Spot.Status) -> [Spot] {
        reduce(into: []) { $0 += $1.doesNotContainStatus(status) }
    }

    func status(_ status: Spot.Status) -> [Spot] {
        reduce(into: []) { $0 += $1.status(status) }
    }

    var filled: [Spot] {
        reduce(into: []) { $0 += $1.filled }
    }

    func update(spots: [Spot], status: Spot.Status) -> [[Spot]] {
        map { $0.update(spots: spots, status: status) }
    }

    func newlyFilled(_ newSpots: [Spot]) -> [[Spot]] {
        map { $0.newlyFilled(newSpots) }
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
    func doesNotContainStatus(_ status: Spot.Status) -> [Spot] {
        filter { !$0.status.contains(status) }
    }

    func status(_ status: Spot.Status) -> [Spot] {
        filter { $0.status == status }
    }

    var horizontal: [Spot] {
        return columns.areSequential && row != nil ? Array(self) : []
    }

    var vertical: [Spot] {
        return rows.areSequential && column != nil ? Array(self) : []
    }

    func update(spots: [Spot], status: Spot.Status) -> [Spot] {
        self.map { column in
            var copy = column
            if column.tile == nil {
                copy.status = []
            } else if spots.contains(where: { $0.sameAs(column) }) {
                copy.status = status
            }
            return copy
        }
    }
}
