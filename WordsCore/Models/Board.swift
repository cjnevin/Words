//
//  Board.swift
//  words
//
//  Created by Chris on 26/10/2019.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation

public struct Board: Equatable, Hashable, Codable {
    public typealias Layout = [[Int]]
    public internal(set) var spots: [[Spot]] = []

    public init(spots: [[Spot]] = []) {
        self.spots = spots
    }

    public init(layout: Layout) {
        let middle = layout.count / 2
        self.spots = layout.enumerated().map { row, columns in
            columns.enumerated().map { column, multiplier in
                let letterMultiplier = Swift.max(1, multiplier < 4 ? multiplier : 1)
                let wordMultiplier = multiplier > 3 ? multiplier - 2 : 1
                return Spot(
                    row: row,
                    column: column,
                    middle: row == middle && column == middle,
                    multiplier: letterMultiplier,
                    wordMultiplier: wordMultiplier,
                    tile: nil)
            }
        }
    }
}

extension Board {
    mutating func lock() {
        spots = spots.reduce(into: []) { buffer, rows in
            buffer.append(rows.reduce(into: []) { columns, column in
                var copy = column
                copy.tile?.movable = false
                columns.append(copy)
            })
        }
    }

    func calculatePlacement(comparingWith newBoard: Board) -> PlacementResult {
        spots.filled.compoundPlacement(newBoard.spots.filled)
    }

    var isEmpty: Bool {
        for row in spots {
            for column in row where column.tile != nil {
                return false
            }
        }
        return true
    }

    func tile(at spot: Spot) -> Tile? {
        spots[spot.row][spot.column].tile
    }

    func tiles(at spots: [Spot]) -> [Tile] {
        spots.compactMap(tile)
    }

    func leftDiff(against: Board) -> [Spot] {
        zip(spots, against.spots).reduce(into: []) { buffer, row in
            zip(row.0, row.1).forEach { oldSpot, newSpot in
                if oldSpot != newSpot {
                    buffer.append(oldSpot)
                }
            }
        }
    }

    func rightDiff(against: Board) -> [Spot] {
        zip(spots, against.spots).reduce(into: []) { buffer, row in
            zip(row.0, row.1).forEach { oldSpot, newSpot in
                if oldSpot != newSpot {
                    buffer.append(newSpot)
                }
            }
        }
    }
    
    public static var defaultLayout: Layout {
        return [
            [5, 0, 0, 2, 0, 0, 0, 5, 0, 0, 0, 2, 0, 0, 5],
            [0, 3, 0, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0, 3, 0],
            [0, 0, 3, 0, 0, 0, 2, 0, 2, 0, 0, 0, 3, 0, 0],
            [2, 0, 0, 3, 0, 0, 0, 2, 0, 0, 0, 3, 0, 0, 2],
            [0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0],
            [0, 4, 0, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0, 4, 0],
            [0, 0, 2, 0, 0, 0, 2, 0, 2, 0, 0, 0, 2, 0, 0],
            [5, 0, 0, 2, 0, 0, 0, 4, 0, 0, 0, 2, 0, 0, 5],
            [0, 0, 2, 0, 0, 0, 2, 0, 2, 0, 0, 0, 2, 0, 0],
            [0, 4, 0, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0, 4, 0],
            [0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0],
            [2, 0, 0, 3, 0, 0, 0, 2, 0, 0, 0, 3, 0, 0, 2],
            [0, 0, 3, 0, 0, 0, 2, 0, 2, 0, 0, 0, 3, 0, 0],
            [0, 3, 0, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0, 3, 0],
            [5, 0, 0, 2, 0, 0, 0, 5, 0, 0, 0, 2, 0, 0, 5]
        ]
    }
}
